require 'net/imap'

class ImportJob < ApplicationJob
  include CableReady::Broadcaster
  queue_as :default

  def perform(args)
    username = args[:email]
    password = args[:password]
    limit = args.fetch(:limit, -1).to_i
    import_lock = ImportLock.create! job_id:, email: username
    status = 0
    imap = Net::IMAP.new('imap.googlemail.com', 993, true, nil, false)
    imap.login(username, password)
    imap.examine('[Gmail]/All Mail')
    uids = imap.uid_search(['ALL']).slice(0..(limit.zero? ? -1 : limit))
    total = uids.length

    uids.each_with_index do |uid, index|
      data = imap.fetch(uid, ['RFC822'])
      next unless data

      message = Mail.new data.first.attr['RFC822']

      Message.create!(
        subject: message.subject,
        delivered_at: message.date,
        sender: message.sender
      )
    rescue Encoding::UndefinedConversionError => e
      Rails.logger.error(e)
      next
    ensure
      status = (index.to_f / total * 100).to_i
      puts "Progress: #{status}%"
      update_progress(status, index, total)
      cable_ready.broadcast
    end

    update_progress(100, total, total)
    cable_ready.broadcast
    imap.logout
  ensure
    import_lock.complete!
  end

  private

  def update_progress(amount, index = nil, total = nil)
    cable_ready['ImportChannel'].set_attribute(
      selector: '#progress-bar>div',
      name: 'style',
      value: "width:#{amount}%"
    )

    cable_ready['ImportChannel'].inner_html(
      selector: '#count',
      html: "Imported: #{index} of #{total} messages"
    )
  end
end

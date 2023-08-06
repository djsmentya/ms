class ImportChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'ImportChannel'
  end
end

require 'net/imap'

class ImportsController < ApplicationController
  before_action :check_credentials, only: :create

  def new; end

  def create
    if ImportLock.exists?(completed_at: nil)
      redirect_to import_path, notice: 'Import in progress. Please wait...'
    else
      ImportJob.perform_later(permitted_params.to_h)
      redirect_to import_path
    end
  end

  def show; end

  private

  def check_credentials
    imap = Net::IMAP.new('imap.googlemail.com', 993, true, nil, false)
    imap.login(permitted_params[:email], permitted_params[:password])
    imap.logout
  rescue Net::IMAP::NoResponseError => e
    redirect_to  root_path, alert: e.message
  end

  def permitted_params
    params.require(:import).permit(:email, :password, :limit)
  end
end

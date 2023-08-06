require 'rails_helper'

RSpec.describe ImportJob, type: :job do
  let(:credentials) { { email: ENV['GMAIL_EMAIL'], password: ENV['GMAIL_PASSWORD'], limit: 3 } }

  describe '#perform' do
    it 'add import lock' do
      expect { ImportJob.perform_now(credentials) }.to change { ImportLock.count }.by(1)
      expect(ImportLock.last.completed_at).to be
      expect(ImportLock.last.email).to eq(credentials[:email])
    end
  end
end

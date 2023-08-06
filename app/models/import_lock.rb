class ImportLock < ApplicationRecord
  def complete!
    update! completed_at: Time.zone.now
  end
end

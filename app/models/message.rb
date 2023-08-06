class Message < ApplicationRecord
  rails_admin do
    exclude_fields :body
  end
end

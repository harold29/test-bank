class Account < ApplicationRecord
  belongs_to :user

  has_many :origin_account, class_name: 'Account', foreign_key: 'origin_account_id'
  has_many :destination_account, class_name: 'Account', foreign_key: 'destination_account_id'
end

class Transaction < ApplicationRecord
  belongs_to :origin_account, class: 'Account'
  belongs_to :destination_account, class: 'Account'
  belongs_to :User
end

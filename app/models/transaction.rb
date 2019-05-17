class Transaction < ApplicationRecord
  enum action: {
    transfer: 0,
    deposit: 1,
    withdraw: 2
  }

  enum status: {
    started: 0,
    in_progress: 1,
    successful: 2,
    failed: 3
  }

  belongs_to :origin_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }
  validates :user, :origin_account, :destination_account, :status, :action, presence: true

  def self.transfer_start(user, origin, destination, amount)
    transfer_log(user, origin, destination, :started, amount)
  end

  def self.transfer_successful(user, origin, destination, amount)
    transfer_log(user, origin, destination, :successful, amount)
  end

  def self.transfer_failed(user, origin, destination, amount)
    transfer_log(user, origin, destination, :failed, amount)
  end

  def self.deposit_start(user, destination, amount)
    deposit_log(user, destination, :started, amount)
  end

  def self.deposit_successful(user, destination, amount)
    deposit_log(user, destination, :successful, amount)
  end

  def self.deposit_failed(user, destination, amount)
    deposit_log(user, destination, :failed, amount)
  end

  def self.by_relation(account_id)
    where("status = ? and (origin_account_id = ? or destination_account_id = ?)", 2, account_id, account_id).order(created_at: :desc)
  end

  def withdraw_log(amount)

  end

  def action_index
    self[:action]
  end

  def status_index
    self[:status]
  end

  private

  def self.transfer_log(user, origin, destination, status, amount)
    create(
      user: user,
      origin_account: origin,
      destination_account: destination,
      amount: amount,
      action: :transfer,
      status: status
    )
  end

  def self.deposit_log(user, destination, status, amount)
    create(
      user: user,
      origin_account: destination,
      destination_account: destination,
      amount: amount,
      action: :deposit,
      status: status
    )
  end
end

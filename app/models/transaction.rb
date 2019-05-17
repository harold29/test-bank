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

  def self.deposit_start(destination, amount)
    deposit_log(destination, :started, amount)
  end

  def self.deposit_successful(destination, amount)
    deposit_log(destination, :successful, amount)
  end

  def self.deposit_failed(destination, amount)
    deposit_log(destination, :failed, amount)
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

  def deposit_log(destination, status, amount)
    create(
      user: current_user,
      origin_account: destination,
      destination_account: destination,
      amount: amount,
      action: :deposit,
      status: status
    )
  end
end

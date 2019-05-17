class Account < ApplicationRecord
  belongs_to :user

  has_many :origin_account, class_name: 'Account', foreign_key: 'origin_account_id'
  has_many :destination_account, class_name: 'Account', foreign_key: 'destination_account_id'

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }
  validates :user, presence: true
  validate

  def initialize(attributes = {})
    super
  end

  def self.by_user_id(id)
    find_by(user_id: id)
  end

  def self.by_account_number(account_number)
    find_by(account_number: account_number)
  end

  def deposit(amount)
    Transaction.deposit_start(self, amount)
    if amount >= 0.0
      self.amount += amount
      if self.save!
        Transaction.deposit_successful(self, amount)
      else
        Transaction.deposit_failed(self, amount)
      end
    else
      self.errors[:base] << 'No destination account'
      Transaction.deposit_failed(self, amount)
    end
  end

  def transfer(destination, amount)
    destination_account = Account.by_account_number(destination)
    Transaction.transfer_start(user, self, destination_account, amount)
    if destination_account
      if funds_available?(amount)
        self.amount -= amount
        destination_account.amount += amount

        if save! && destination_account.save!
          Transaction.transfer_successful(user, self, destination_account, amount)
          return true
        else
          Transaction.transfer_failed(user, self, destination_account, amount)
          return false
        end
      else
        self.errors[:base] << 'No funds available'
        Transaction.transfer_failed(user, self, destination_account, amount)
        return false
      end
    else
      self.errors[:base] << 'No existing destination account'
      Transaction.transfer_failed(user, self, destination_account, amount)
      return false
    end
  end

  def withdraw(amount)
    if funds_available?(amount)
      self.amount -= amount
      self.save!
    else
      self.errors[:base] << 'No funds available'
    end
  end

  private

  def funds_available?(amount)
    self.amount >= amount
  end


end

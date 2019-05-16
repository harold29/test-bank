class Account < ApplicationRecord
  belongs_to :user

  has_many :origin_account, class_name: 'Account', foreign_key: 'origin_account_id'
  has_many :destination_account, class_name: 'Account', foreign_key: 'destination_account_id'

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }
  validates :user, presence: true

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
    if amount >= 0.0
      self.amount += amount
      self.save!
    else
      # EXCEPTION
    end
  end

  def transfer(destination, amount)
    destination_account = Account.by_account_number(destination)
    if destination_account
      if funds_available?(amount)
        self.amount -= amount
        self.save!
        destination_account.amount += amount
        destination_account.save!
      else
        # EXCEPTION
      end
    else
      # EXCEPTION
    end
  end

  def withdraw(amount)
    if funds_available?(amount)
      self.amount -= amount
      self.save!
    else
      # EXCEPTIOn
    end
  end

  private

  def funds_available?(amount)
    self.amount >= amount
  end


end

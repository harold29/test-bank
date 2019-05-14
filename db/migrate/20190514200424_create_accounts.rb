class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.float :amount
      t.string :account_number
      t.boolean :active

      t.timestamps
    end
  end
end

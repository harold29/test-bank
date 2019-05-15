class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references, :user
      t.string, :status
      t.string, :action
      t.float, :amount
      t.references :origin_account
      t.references :destination_account

      t.timestamps
    end
  end
end

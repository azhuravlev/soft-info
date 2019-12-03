class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.string :role, null: false
    end
  end
end

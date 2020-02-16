class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :link
      t.json :info

      t.timestamps
    end
  end
end

class CreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.text :styles

      t.timestamps
    end
  end
end

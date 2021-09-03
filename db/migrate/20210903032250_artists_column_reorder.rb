class ArtistsColumnReorder < ActiveRecord::Migration[6.1]
  def change
    change_table :artists do |t|
      t.change :studio, :string, after: :styles
      t.change :minimum, :decimal, precision: 10, scale: 2, after: :studio
    end
  end
end

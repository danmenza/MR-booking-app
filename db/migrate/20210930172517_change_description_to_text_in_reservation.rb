class ChangeDescriptionToTextInReservation < ActiveRecord::Migration[6.1]
  def change
    change_column :reservations, :description, :text
  end
end

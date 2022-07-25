class Add18OrOlderToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :legal_age, :boolean, after: :cover_up
  end
end

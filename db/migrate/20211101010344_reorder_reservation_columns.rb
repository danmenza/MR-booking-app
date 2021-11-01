class ReorderReservationColumns < ActiveRecord::Migration[6.1]
  def change
     change_column :reservations, :appt_start, :date, after: :color
  end
end

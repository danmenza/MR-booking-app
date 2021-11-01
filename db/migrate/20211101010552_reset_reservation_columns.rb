class ResetReservationColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :reservations, :appt_start
    remove_column :reservations, :appt_end
    add_column :reservations, :appt_start, :date
    add_column :reservations, :appt_end, :date
  end
end

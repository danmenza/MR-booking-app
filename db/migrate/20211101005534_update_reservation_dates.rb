class UpdateReservationDates < ActiveRecord::Migration[6.1]
  def change
    rename_column :reservations, :appt_date, :appt_start
    change_column :reservations, :color, :boolean, after: :description
    change_column :reservations, :appt_start, :date, after: :color
    add_column :reservations, :appt_end, :date, after: :appt_start
  end
end

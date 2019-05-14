class AddTypeToPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :type, :string
  end
end

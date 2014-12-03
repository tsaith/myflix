class RenameNameAsFullNameInUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :name, :full_name
    end
  end
end

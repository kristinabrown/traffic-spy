class Createtables3 < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.string :browser_info
    end
  end
end

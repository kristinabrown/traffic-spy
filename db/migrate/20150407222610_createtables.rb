class Createtables < ActiveRecord::Migration
  def change
    create_table :request_types do |t|
      t.string :verb_name
    end
  end
  
  def change
    create_table :ips do |t|
      t.string :address
    end
  end
  
  def change
    create_table :user_agents do |t|
      t.string :browser_info
    end
  end
  
  def change 
    create_table :events do |t|
      t.string :name
    end
  end
  
  def change
    create_table :resolutions do |t|
      t.string :height
      t.string :width
    end
  end
end

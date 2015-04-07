class Createsourcetable < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :identifier
      t.string :root_url
      
      t.timestamps
    end
  end
end

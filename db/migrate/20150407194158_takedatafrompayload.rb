class Takedatafrompayload < ActiveRecord::Migration
  def change
    create_table :payloads do |t|
      t.integer :source_id
      t.string  :url
      t.string  :requested_at
      t.integer :responded_in
      t.integer :referrer_id
      t.integer :request_type_id
      
  end
end

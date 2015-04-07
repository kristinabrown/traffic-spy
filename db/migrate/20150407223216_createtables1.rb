class Createtables1 < ActiveRecord::Migration
  def change
    create_table :request_types do |t|
      t.string :verb_name
    end
  end
end

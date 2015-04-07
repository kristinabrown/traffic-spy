class Referrertable < ActiveRecord::Migration
  def change
    create_table :referrers do |t|
      t.string :referrer_url
    end
  end
end

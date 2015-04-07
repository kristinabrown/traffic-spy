class Updateurlcolumn < ActiveRecord::Migration
  def change
    rename_column :payloads, :url, :url_id
  end
end

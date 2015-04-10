class Addrelativepathcolumn < ActiveRecord::Migration
  def change
    add_column :urls, :relative_path, :string
  end
end

class Renameresolutioncolumn < ActiveRecord::Migration
  def change
    rename_column :payloads, :resolution_size_id, :resolution_id 
  end
end

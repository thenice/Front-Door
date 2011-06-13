class ChangeTokenTokenToValue < ActiveRecord::Migration
  def self.up
    rename_column :tokens, :token, :value
  end

  def self.down
    rename_column :tokens, :value, :token
  end
  
end

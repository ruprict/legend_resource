class CreateLegends < ActiveRecord::Migration
  def self.up
    create_table :legends do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :legends
  end
end

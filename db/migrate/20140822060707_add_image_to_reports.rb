class AddImageToReports < ActiveRecord::Migration
  def self.up
    add_attachment :reports, :image
  end

  def self.down
    remove_attachment :reports, :image
  end

end

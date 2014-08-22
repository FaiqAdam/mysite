class Report < ActiveRecord::Base

	before_create :create_reference
  	before_create :update_report_number



	validates :weight, presence: true
	self.per_page = 10



  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def self.to_csv
	  CSV.generate do |csv|
	    csv << column_names
	    all.each do |report|
	      csv << report.attributes.values_at(*column_names)
	    end
	  end
	end


	protected

	def update_report_number 
		if Report.last.present? 
			self.reportnumber = Report.last.reportnumber + 1 
		else 
			self.reportnumber = 20000 
		end 
	end




	  def create_reference
	    self.reference = SecureRandom.hex(6)
	  end


end

# https://github.com/jnicklas/carrierwave/wiki/How-to:-Validate-attachment-file-size
#require 'file_size_validator' 
class Source < ActiveRecord::Base
  attr_accessible :name, :publish_date, :public, :image, :user_id
  belongs_to :users
  has_many :recipes, dependent: :destroy
  has_many :usersbooks#, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :user_id, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :publish_date, presence: true
  #validates :image, :file_size => { :maximum => 0.5.megabytes.to_i } 

  #def is_public?
  #	self.public
  #end

  def user
  	User.find(self.user_id)
  end

  def book(uid)
    Usersbook.where("user_id = #{uid} and source_id=#{self.id}")
  end

  def is_usersbook(uid)
    u=Usersbook.where("user_id = #{uid} and source_id=#{self.id}")
    true if u.size>0
  end

  def self.public_sources
    #where("public = 't'").order("publish_date DESC")
    where("public = ?", true).order("publish_date DESC")
  end

  #before_save { |source| source.name = name.downcase }
end

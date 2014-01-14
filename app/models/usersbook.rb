class Usersbook < ActiveRecord::Base
  attr_accessible :source_id, :user_id

  has_one :user
  belongs_to :source

  validates :user_id, presence: true
  validates :source_id, presence: true
end

class Sensor < ActiveRecord::Base

  has_many :components
  has_many :boards, through: :components
  has_many :kits, through: :components
  belongs_to :measurement

  attr_accessor :latest_reading

  has_ancestry
  validates_presence_of :name, :description#, :unit

end

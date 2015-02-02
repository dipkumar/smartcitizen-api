require 'geohash'

class Device < ActiveRecord::Base

  belongs_to :owner
  belongs_to :kit

  belongs_to :owner, class_name: 'User'
  validates_presence_of :owner, :mac_address, :name
  validates_format_of :mac_address, with: /\A([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}\z/
  validates_uniqueness_of :mac_address

  reverse_geocoded_by :latitude, :longitude
  # reverse_geocoded_by :latitude, :longitude do |obj, results|
  #   if geo = results.first
  #     obj.address = geo.address
  #     obj.city = geo.city
  #     obj.postal_code = geo.postal_code
  #     obj.state = geo.state
  #     obj.state_code = geo.state_code
  #     obj.country = geo.country
  #     obj.country_code = geo.country_code
  #   end
  # end
  # after_validation :reverse_geocode

  # these get overridden the device is a kit
  has_many :components, as: :board
  has_many :sensors, through: :components

  before_save :calculate_geohash

  def components
    kit ? kit.components : super
  end

  def sensors
    kit ? kit.sensors : super
  end

  def readings
    Reading.where(device_id: id)
  end

private

  def calculate_geohash
    # include ActiveModel::Dirty
    # if latitude.changed? or longitude.changed?
    if latitude.is_a?(Float) and longitude.is_a?(Float)
      self.geohash = GeoHash.encode(latitude, longitude)
    end
  end

end


# REDIS
# online_kits = [12,13,4,546,45,4564,46,75,68,97] - TTL 15 minutes? // last_recorded_at
# online? - online_kits.include?(id)
# offline? - !online_kits.include?(id)

# exposure - indoor / outdoor
# search by name, city & description
# date range - granulation hour/day/week/month/year/lifetime
# filter by:
#   online
#   offline
#   kit type
#   firmware version
#   ...
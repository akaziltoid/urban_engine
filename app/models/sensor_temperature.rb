class SensorTemperature
  attr_reader :uuid

  def self.find(uuid)
    raise ActiveRecord::RecordNotFound if uuid != Thermostat.uuid
    new(uuid)
  end

  def initialize(uuid)
    @uuid = uuid
  end

  def value
    Rails.cache.fetch("thermostats/#{uuid}/sensor_temperature_value") { 20 }
  end

  def value= value
    Rails.cache.write("thermostats/#{uuid}/sensor_temperature_value", value)
  end

  def to_raw
    value
  end
end
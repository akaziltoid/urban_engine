class Thermostat
  attr_reader :uuid, :mode, :setpoint_temperature_value, :can_heat, :can_cool, :minimum_duration

  def initialize(uuid)
    @uuid = uuid
    settings = self.class.load_settings(uuid)

    @can_heat = settings[:can_heat]
    @can_cool = settings[:can_cool]
    @minimum_duration = settings[:minimum_duration]

    @mode = settings[:mode]

    @setpoint_temperature_value = settings[:setpoint_temperature_value]
  end

  def self.find(uuid)
    raise ActiveRecord::RecordNotFound if uuid != self.uuid
    new(uuid)
  end

  def self.reset(uuid)
    raise ActiveRecord::RecordNotFound if uuid != self.uuid
    Rails.cache.delete_matched("*thermostats/#{uuid}/*")
  end

  def self.load_settings(uuid)
    Rails.cache.fetch("thermostats/#{uuid}/settings") do
      {
        mode: 'manual',
        setpoint_temperature_value: 20.7,
        can_heat: true,
        can_cool: false,
        minimum_duration: 5
      }
    end.with_indifferent_access
  end

  def self.uuid
    ENV.fetch 'THERMOSTAT_UUID', '5042c503-0538-428f-a563-0a0b2d9b89e4'
  end

  def status
    self.previous_status = if inactive?
                             mode
                           elsif manual?
                             if can_power_off?
                               if can_heat && setpoint_temperature_value > sensor_temperature_value
                                 self.latest_power_on = DateTime.now if previous_status != 'heating'
                                 'heating'
                               elsif can_cool && setpoint_temperature_value < sensor_temperature_value
                                 self.latest_power_on = DateTime.now if previous_status != 'cooling'
                                 'cooling'
                               else
                                 'off'
                               end
                             else
                               previous_status
                             end
                           end
  end

  def previous_status
    Rails.cache.fetch("thermostats/#{uuid}/previous_status") { 'off' }
  end

  def previous_status= status
    Rails.cache.write("thermostats/#{uuid}/previous_status", status)
  end

  def sensor_temperature_value
    SensorTemperature.find(uuid).value
  end

  def latest_power_on
    Rails.cache.read("thermostats/#{uuid}/latest_power_on")
  end

  def latest_power_on= latest_power_on
    Rails.cache.write("thermostats/#{uuid}/latest_power_on", latest_power_on)
  end

  def can_power_off?
    return true unless latest_power_on.is_a? DateTime
    latest_power_on + minimum_duration.minutes < DateTime.now
  end

  def inactive?
    mode == 'inactive'
  end

  def manual?
    mode == 'manual'
  end

  def latest_power_on_utc
    latest_power_on && latest_power_on.utc.iso8601
  end

  def to_raw
    %w[mode status setpoint_temperature_value sensor_temperature_value latest_power_on_utc minimum_duration].map do |attribute|
      send attribute
    end.join('|')
  end
end

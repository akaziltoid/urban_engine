class Raw::SensorTemperaturesController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def update
    sensor_temperature = SensorTemperature.find(params[:uuid])
    sensor_temperature.value = params[:value].to_f
    render plain: sensor_temperature.to_raw
  end
end

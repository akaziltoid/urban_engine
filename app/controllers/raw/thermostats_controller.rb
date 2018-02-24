class Raw::ThermostatsController < ActionController::Base
  def show
    thermostat = Thermostat.find(params[:uuid])
    render plain: thermostat.to_raw
  end

  def reset
    Thermostat.reset(params[:uuid])
    render plain: 'ok'
  end
end

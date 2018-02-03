
class Listener::LocationUpdatesController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def create
    location_update = LocationUpdate.new location_update_params
    if location_update.save(context: :listener_create)
      render plain: 'success', status: :created
    else
      render plain: 'failure', status: :unprocessable_entity
    end
  rescue Exception => e
    Rollbar.warning(e)
    render plain: 'failure', status: :unprocessable_entity
  end


  private

  def location_update_params
    params.permit(:latitude, :longitude, :recorded_at, :accuracy, :altitude)
  end
end

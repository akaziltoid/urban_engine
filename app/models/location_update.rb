class LocationUpdate < ApplicationRecord
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :recorded_at, presence: true
  validates :accuracy, numericality: { greater_than_or_equal_to: 0 }

  after_validation :report_validation_errors_to_rollbar, on: :listener_create
end

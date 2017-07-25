# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  DOMAIN = "localhost:8080"
elsif Rails.env.production?
  # TODO: define client domain for production
  DOMAIN = "derivasurbanas.edu.co"
end

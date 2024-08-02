# frozen_string_literal: true

Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  lookup: :ipinfo_io,         # name of geocoding service (symbol)
  ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  language: :en,              # ISO-639 language code

  # IP address geocoding service (default :ipinfo_io)
  ipinfo_io: {
    api_key: '36c6eba6563a08' # put your API key here
  }
)

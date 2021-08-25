Geocoder.configure(
  timeout: 3, # geocoding service timeout (secs)
  lookup: (Rails.env.production? ? :google : :nominatim), # name of geocoding service (symbol)
  google: {
    api_key: ENV.fetch('GEOCODER_API_KEY')
  },
  ip_lookup: :ipinfo_io, # name of IP address geocoding service (symbol)
  ipinfo_io: {
    api_key: ENV.fetch('IP_INFO_API_KEY') # API key for ip lookup service
  },
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  language: :en, # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  cache: Rails.cache, # cache object (must respond to #[], #[]=, and #del)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  units: :mi # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)

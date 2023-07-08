# frozen_string_literal: true

require 'capybara/rspec'

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.always_include_port = true
  # This is where the server will listen.  We use this same `server_host` when
  # making requests in our browser etc.
  config.server_host = ENV.fetch('HOSTNAME', 'localhost')
end

CAPYBARA_DEVICE_RESOLUTIONS = {
  phone: [360, 740], # Samsung Galaxy S8, portrait
  tablet: [768, 1024], # iPad mini, portrait
  laptop: [1366, 768], # Standard 720p, landscape
  desktop: [1920, 1080] # Standard 1080p, landscape
}.freeze

# Use with `device: :phone, orientation: :portrait` in your test metadata and
# the browser will get resized to the correct size.
#
# Defaults to the last key in the list (desktop).
def set_capybara_screen_resolution(device: nil, orientation: nil)
  device ||= CAPYBARA_DEVICE_RESOLUTIONS.keys.last
  # This will blow up if the device isn't in the list.
  resolution = CAPYBARA_DEVICE_RESOLUTIONS.fetch(device)

  # Set up the orientation.
  case orientation
  when :portrait
    resolution.sort!
  when :landscape
    resolution.sort!.reverse!
  end

  Capybara.page.current_window.resize_to(*resolution)
end

Capybara.javascript_driver = :selenium

class HomeController < ApplicationController
  include RpiTurnstile::Verifiable

  def show
  end

  def multiple
  end

  def submit
    notice = rpi_turnstile_verified? ? "✅ Turnstile verification passed." : "❌ Turnstile verification failed."

    redirect_to '/', notice: notice
  end
end

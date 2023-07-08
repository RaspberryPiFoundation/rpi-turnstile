# RpiTurnstile

ViewComponent and Stimulus controller for integration with Cloudflare Turnstile

## Usage

Firstly you need to set `CLOUDFLARE_TURNSTILE_SITEKEY` and `CLOUDFLARE_TURNSTILE_SECRET` in your environment.  Test keys [are available](https://developers.cloudflare.com/turnstile/reference/testing/) if you've not got actual keys/secrets to hand.

To use the component in your page, you can render the `RpiTurnstile::TurnstileComponent` in your view or component, inside the form that needs the check.

```erb
<%= form_with do |form| %>
  <%= render RpiTurnstile::TurnstileComponent.new %>
  <%= form.submit "Submit" %>
<% end %>
```

Then in the controller that handles the POST from the form, include the `RpiTurnstile::Verifiable` module, which adds in the `rpi_turnstile_verified?` method, which you can call to check the validity of the form.

```ruby
  include RpiTurnstile::Verifiable


  def submit
    # Do some real work here...
    notice = rpi_turnstile_verified? ? "✅" : "❌"

    redirect_to '/', notice:
  end
```

Check out the Home controller in the [dummy app](spec/dummy/app/controllers/home_controller.rb) and its [associated views](spec/dummy/app/views/home/show.html.erb).


## Installation

Add this line to your application's Gemfile:

```ruby
gem "rpi_turnstile"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rpi_turnstile
```

## Demo app

To see the component in the demo app, run

```
bundle exec rails s
```

and head to port 3000.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

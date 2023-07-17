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

## Customising

There are [myriad options](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#configurations) that the widget can take, however so far we only support:

* language (default to `I18n.locale` or `en`)
* theme (default to `auto`)
* size (default to `normal`)

I'm sure more will be added in future.  You can also add HTML attributes through the `attrs` parameter, e.g. `class`, `id`, etc.

To make use of these options, add them to the `new` call when rendering.

```ruby
render RpiTurnstile::TurnstileComponent.new(attrs: { class: 'my-extra-css', id: 'woo'}, size: 'compact')
```

## Testing your integration

In order for the component to render, you need to set the site key.  Also when testing you might want to check what happens when verification fails.

Firstly, to stub the site key, you need to stub the `RpiTurnstile::Api::SITEKEY` constant with a value.

```ruby
stub_const('RpiTurnstile::Api::SITEKEY', 'abc')
```

That should allow the component to render.

Secondly, to stub and check what happens when the API verifies (or not), you can stub the `RpiTurnstile::Api#siteverify` class method:

```rspec
allow(RpiTurnstile::Api).to receive(:siteverify).and_return(true)
```

Return `false` here if you want verification to fail.

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

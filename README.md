# RpiTurnstile

A ViewComponent for integrating Cloudflare Turnstile, wrapping the
[cloudflare-turnstile-rails](https://github.com/vkononov/cloudflare-turnstile-rails) gem.

That gem supplies the client-side script loading and the server-side token verification; this
gem wraps them in a ViewComponent and a controller concern, and reads its configuration from the
environment.  You don't need to add `cloudflare-turnstile-rails` to your Gemfile yourself, or run
its install generator — it comes in as a dependency and is configured for you.

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

`rpi_turnstile_verified?` reads the token from the `cf-turnstile-response` parameter for you, and
sends the client's IP (`request.remote_ip`) along with it.  Cloudflare checks that IP against the
one the token was issued to, which is an extra bit of protection against a token being replayed
from elsewhere.

If your app sits behind a proxy or CDN that isn't configured as a trusted proxy, `request.remote_ip`
will be the proxy's address rather than the client's, and verification will start failing.  Pass
`remoteip: nil` to leave it out of the request:

```ruby
rpi_turnstile_verified?(remoteip: nil)
```

Any other keyword arguments are passed through to Cloudflare too, so you can add
[`idempotency_key`](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/#accepted-parameters)
or override `remoteip` with an address of your own.

If you need more than a yes/no answer — the error codes, say, or the hostname the token came from —
`rpi_turnstile_verified` (without the `?`) takes the same arguments and returns the full
[`VerificationResponse`](https://github.com/vkononov/cloudflare-turnstile-rails):

```ruby
result = rpi_turnstile_verified
result.success?  # => false
result.errors    # => ["timeout-or-duplicate"]
```

Check out the Home controller in the [dummy app](spec/dummy/app/controllers/home_controller.rb) and its [associated views](spec/dummy/app/views/home/show.html.erb).

## Customising

There are [myriad options](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#configurations) that the widget can take.  You can pass any of these options in to the component as arguments. e.g.

* language (default to `I18n.locale` or `en`)
* theme
* size

Options are rendered as `data-*` attributes on the widget container, so you can write them either
as shown in the Cloudflare docs (with dashes) or with the more usual Ruby underscores —
`'response-field-name'` and `response_field_name` both produce `data-response-field-name`.  You can
also add HTML attributes through the `attrs` parameter, e.g. `class`, `id`, etc.

To make use of these options, add them to the `new` call when rendering.

```ruby
render RpiTurnstile::TurnstileComponent.new(attrs: { class: 'my-extra-css', id: 'woo'}, size: 'compact')
```

The container always gets the `cf-turnstile` class (which is how Cloudflare's script finds it) plus
`rpi-turnstile` for your own styling.  Anything you pass as `attrs[:class]` is added alongside them.

## Testing your integration

In order for the component to render, you need to set the site key.  Also when testing you might want to check what happens when verification fails.

Firstly, to stub the site key, you need to stub the `RpiTurnstile::Api::SITEKEY` constant with a value.

```ruby
stub_const('RpiTurnstile::Api::SITEKEY', 'abc')
```

That should allow the component to render.

Secondly, to stub and check what happens when the API verifies (or not), you can stub the `RpiTurnstile::Api.verify` class method:

```ruby
allow(RpiTurnstile::Api).to receive(:verify).and_return(
  instance_double(Cloudflare::Turnstile::Rails::VerificationResponse, success?: true)
)
```

Pass `success?: false` if you want verification to fail.  Add `errors:` to the double if the code
under test reads them.

Stubbing `verify` is the recommended seam, because it short-circuits before any HTTP call is
made.  If you don't stub it, `cloudflare-turnstile-rails` will substitute a dummy token for a blank
response in the test environment and still attempt a real call to Cloudflare.  You can turn that
substitution off in an initializer:

```ruby
Cloudflare::Turnstile::Rails.configure do |config|
  config.auto_populate_response_in_test_env = false
end
```

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

## Testing

Tests are run using rspec, and can be run against both Rails 7 and 8 using [Appraisal](https://github.com/thoughtbot/appraisal)

```
bundle exec appraisal rspec
```

## Demo app

To see the component in the demo app, run

```
bundle exec rails s
```

and head to port 3000.

To run with a specific Rails version, you can use the [Appraisal](https://github.com/thoughtbot/appraisal)

```
bundle exec appraisal rails-8 rails s

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

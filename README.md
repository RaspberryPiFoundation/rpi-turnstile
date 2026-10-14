# RpiTurnstile

> [!WARNING]
> **This gem is deprecated.** It is now a thin wrapper around
> [cloudflare-turnstile-rails](https://github.com/vkononov/cloudflare-turnstile-rails),
> and will not receive new features. Please migrate to that gem directly — see
> [Deprecation](#deprecation) below.

ViewComponent for integration with Cloudflare Turnstile, built on [cloudflare-turnstile-rails](https://github.com/vkononov/cloudflare-turnstile-rails).

## Deprecation

Everything this gem does is provided by `cloudflare-turnstile-rails`, which is already installed as a dependency.  To migrate:

1. Replace `gem "rpi_turnstile"` with `gem "cloudflare-turnstile-rails"` in your Gemfile.
2. Run `bin/rails generate cloudflare_turnstile:install` to create `config/initializers/cloudflare_turnstile.rb`, and either rename your environment variables or point the initializer at the existing ones:

   | rpi_turnstile                  | cloudflare-turnstile-rails        |
   |--------------------------------|-----------------------------------|
   | `CLOUDFLARE_TURNSTILE_SITEKEY` | `CLOUDFLARE_TURNSTILE_SITE_KEY`   |
   | `CLOUDFLARE_TURNSTILE_SECRET`  | `CLOUDFLARE_TURNSTILE_SECRET_KEY` |

   To keep the widget following the current locale, as this gem did, add `config.default_data = { language: -> { I18n.locale } }`.

3. Update your views, controllers and tests:

   | rpi_turnstile                                                       | cloudflare-turnstile-rails                                                 |
   |---------------------------------------------------------------------|----------------------------------------------------------------------------|
   | `render RpiTurnstile::TurnstileComponent.new(size: 'compact')`      | `cloudflare_turnstile_tag data: { size: 'compact' }`                       |
   | `render RpiTurnstile::TurnstileComponent.new(attrs: { id: 'foo' })` | `cloudflare_turnstile_tag id: 'foo'`                                       |
   | `include RpiTurnstile::Verifiable`                                  | Not needed — `valid_turnstile?` is available in all controllers           |
   | `rpi_turnstile_verified?`                                           | `valid_turnstile?` (see note below)                                        |
   | `stub_const('RpiTurnstile::Api::SITEKEY', 'abc')`                   | `Cloudflare::Turnstile::Rails.configuration.site_key = 'abc'`              |
   | `allow(RpiTurnstile::Api).to receive(:siteverify).and_return(true)` | Use a [test secret key](https://github.com/vkononov/cloudflare-turnstile-rails#automated-testing-of-your-integration) |

   Note that `valid_turnstile?` differs from `rpi_turnstile_verified?` in a few ways:
   * it sets `flash[:alert]` on failure unless you pass `model:`;
   * it raises `Cloudflare::Turnstile::Rails::ConfigurationError` if no secret key is configured, rather than passing silently;
   * it does not skip verification when no site key is configured.

While you migrate, this gem copies `CLOUDFLARE_TURNSTILE_SITEKEY` and `CLOUDFLARE_TURNSTILE_SECRET` into the `cloudflare-turnstile-rails` configuration (unless it has already been set), so `cloudflare_turnstile_tag` and `valid_turnstile?` can be used alongside the deprecated component.

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

There are [myriad options](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/widget-configurations/) that the widget can take.  You can pass any of these options in to the component as arguments, and they are rendered as `data-*` attributes on the widget. e.g.

* language (default to `I18n.locale` or `en`)
* theme
* size

Callback options (e.g. `callback`) take the name of a global JavaScript function.  You can also add HTML attributes through the `attrs` parameter, e.g. `class`, `id`, etc.

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
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

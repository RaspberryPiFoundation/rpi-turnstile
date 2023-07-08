# frozen_string_literal: true

module BeRenderedMatcher
  extend RSpec::Matchers::DSL

  matcher :be_rendered do
    match do |actual|
      actual.has_xpath?('//head | //body', visible: false)
    end

    description do
      'be rendered'
    end
  end
end

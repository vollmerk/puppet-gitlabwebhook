source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 4.6'
gem 'facter', ENV.key?('FACTER_VERSION') ? "~> #{ENV['FACTER_VERSION']}" : '~> 2.4.6'
gem 'metadata-json-lint'
gem 'puppetlabs_spec_helper', '>= 2.1.1'
gem 'puppet-lint', '>= 2'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-absolute_classname-check'
gem 'puppet-lint-undef_in_function-check'
gem 'puppet-lint-leading_zero-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-file_ensure-check'
gem 'puppet-lint-param-docs', '>= 1.3.0'
gem 'rspec-puppet', '~> 2.3'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'
end

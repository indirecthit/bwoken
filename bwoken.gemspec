# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bwoken/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'bwoken'
  gem.version       = Bwoken::VERSION
  gem.description   = %q{iOS UIAutomation Test Runner}
  gem.summary       = %q{Runs your UIAutomation tests from the command line for both iPhone and iPad; supports coffeescript}

  gem.authors       = ['Brad Grzesiak', 'Jaymes Waters']
  gem.email         = ['brad@bendyworks.com', 'jaymes@bendyworks.com']
  gem.homepage      = 'https://bendyworks.github.com/bwoken'

  gem.files        = Dir['LICENSE', 'README.md', 'bin/**/*', 'lib/**/*']
  gem.require_path = 'lib'

  gem.bindir        = 'bin'
  gem.executables   = ['unix_instruments.rb']

  gem.add_dependency 'coffee-script-source'
  gem.add_dependency 'colorful'
  gem.add_dependency 'execjs'
  gem.add_dependency 'json_pure' if RUBY_VERSION =~ /^1\.8\./
  gem.add_dependency 'rake'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
end

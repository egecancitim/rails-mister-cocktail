ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger' # Rails 6.1 + Ruby 3.3 needs Logger loaded before ActiveSupport.
require 'yaml'

# Ruby 3.3 + Psych 5 defaults can reject YAML aliases used by legacy Rails/Webpacker
# config loaders. Force aliases on when callers do not specify it explicitly.
module YamlAliasesCompat
  def load(yaml, **kwargs)
    super(yaml, **{ aliases: true }.merge(kwargs))
  end

  def safe_load(yaml, **kwargs)
    super(yaml, **{ aliases: true }.merge(kwargs))
  end
end

YAML.singleton_class.prepend(YamlAliasesCompat)
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.

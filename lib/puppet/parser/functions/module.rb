module Puppet::Parser::Functions
  newfunction(:module) do |args|
    uninstalled = args.reject { |mod| Puppet::Module.find(mod) }
    unless uninstalled.empty?
      raise Puppet::ParseError, <<-MSG.gsub(/^        /, '')
        Pod depends on modules which aren't installed.
        Required modules: #{uninstalled.inspect}
        Modules can be installed by running `drop module <modname>`.
      MSG
    end
  end
end

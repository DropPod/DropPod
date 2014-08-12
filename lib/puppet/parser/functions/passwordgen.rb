module Puppet::Parser::Functions
  newfunction(:passwordgen, :type => :rvalue) do |args|
    args << lookupvar('macaddress')
    srand Digest::SHA1.hexdigest(args.inspect).to_i(16)
    Digest::SHA1.hexdigest(rand.to_s)
  end
end

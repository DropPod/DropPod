Facter.add("user_accounts") do
  setcode do
    cmd = "dscl . -list /Users UniqueID | awk '$2 > 500 { print $1; }'"
    Facter::Util::Resolution.exec(cmd).split("\n").join(':')
  end
end

Facter.add("id") do
  confine :kernel => :Darwin
  setcode "logname"
end

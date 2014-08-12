# Source the contents of the .profile.d directory
if [ -r ~/.profile.d ]; then
  for sh in ~/.profile.d/*.sh ; do
    [ -r "${sh}" ] && source "${sh}"
  done
fi
unset sh

# Source the contents of any shell-specific .profile.d directory
if [ -r ~/.${SHELL##*/}.profile.d ]; then
  for sh in ~/.${SHELL##*/}.profile.d/*.sh ; do
    [ -r "${sh}" ] && source "${sh}"
  done
fi
unset sh

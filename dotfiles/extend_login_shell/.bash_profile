# extend login env by dynamic source everything from ~/.profile.d

for profile in ~/.profile.d/*.sh; do
    test -r "$profile" && source "$profile"
done
unset profile

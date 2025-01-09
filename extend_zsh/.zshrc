# extend zsh by dynamic source everything from ~/.zsh.d

for profile in ~/.zsh.d/*.zsh; do
    test -r "$profile" && source "$profile"
done
unset profile

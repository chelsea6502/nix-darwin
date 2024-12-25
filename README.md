# Install steps
```

# install xcode
xcode-select --install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# activate nix
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# download config
mkdir -p ~/.config/
cd ~/.config/
git clone https://github.com/chelsea6502/nix-darwin/
cd ./nix-darwin

# replace the hostname with the current one
sed -i '' "s/Chelseas-Macbook-Air/$(scutil --get LocalHostName)/g" flake.nix

# install nix-darwin
nix run nix-darwin -- switch --flake ~/.config/nix-darwin

# reset shell
zsh

# run
nix-full
```

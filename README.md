# Installation

# Install Xcode and Nix
xcode-select --install && \
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Activate Nix
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Setup nix-darwin
git clone https://github.com/chelsea6502/nix-darwin/ ~/.config/nix-darwin && \
sed -i '' "s/Chelseas-Macbook-Air/$(scutil --get LocalHostName)/g" ~/.config/nix-darwin/flake.nix && \
nix run nix-darwin -- switch --flake ~/.config/nix-darwin

# Finalize
zsh && nix-full

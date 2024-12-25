# Install steps
```

xcode-select --install

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

mkdir -p ~/.config/

cd ~/.config/

git clone https://github.com/chelsea6502/nix-darwin/

nix run nix-darwin -- switch --flake ~/.config/nix-darwin

nix-full
```

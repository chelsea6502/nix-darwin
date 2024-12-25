# Install steps
```

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

mkdir -p ~/.config/

cd ~/.config/

git clone https://github.com/chelsea6502/nix-darwin/

nix run nix-darwin -- switch --flake ~/.config/nix-darwin

zsh

darwin-rebuild switch --flake ~/.config/nix-darwin

zsh

nix-full
```

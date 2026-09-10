#!/usr/bin/env bash
set -e
cd "$HOME/dotfiles/"

if git diff --quiet HEAD; then
    echo "No changes detected. Skipping rebuild."
    exit 0
fi

git add .

cleanup_on_failure() {
    echo -e "\n Build failed! Rolling back staged git changes..."
    git restore --staged .
}

trap cleanup_on_failure ERR

echo "Rebuilding..."
sudo nixos-rebuild switch --flake nix/.#SNAIL
trap - ERR

current_gen=$(nixos-rebuild list-generations | grep 'True$' | awk '{print $1}')

git commit -m "NixOS Rebuild: $current_gen"
echo "System rebuilt."

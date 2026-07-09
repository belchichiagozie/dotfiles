#!/usr/bin/env bash
set -e
cd ~/dotfiles

if git diff --quiet HEAD; then
    echo "No changes detected, exiting."
    exit 0
fi

echo "Rebuilding NixOS..."
sudo nixos-rebuild switch --flake .#SNAIL

current_gen=$(nixos-rebuild list-generations | grep current -i)

git add .
git commit -m "NixOS Rebuild Generation: $current_gen"

echo "Rebuild complete."

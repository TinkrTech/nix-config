# Nix-Config

This repo contains the configuration files for all NixOS machines.

# Creating a new host

## Prerequisites

1. NixOS installation media (Guide available on [nixos.org](https://nixos.org/download))
2. Choose a hostname - Following the theme, it should be a character in The Stormlight Archives

## Installation

1. Boot into the NixOS Live installer
2. Partition & format the boot drive with GParted (available in the graphical ISO)
3. Mount the drives
    ```sh
    lsblk
    sudo mount <root partition> /mnt
    sudo mkdir -p /mnt/boot
    sudo mount <boot partition> /mnt/boot
    sudo swapon <swap partition> # if applicable
    ```
4. Create a GitHub SSH Key
    1. Run 
        ```sh
        mkdir -p /mnt/home/jade/.ssh
        ssh-keygen -f /mnt/home/jade/.ssh/github -N ""
        ```
    2. Copy the contents of `/mnt/home/jade/.ssh/github.pub` to your clipboard
    3. Navigate to [Github SSH Keys](https://github.com/settings/keys/ssh/new)
    4. Set the title to the machine, keep the key type as "Authentication Key", and paste your public key into the key section
5. Clone this Repo
    1. Create the directory
        ```sh
        sudo mkdir -p /mnt/home/jade/nixos
        cd /mnt/home/jade/nixos
        ``` 
    2. Run
        ```sh
        git clone git@github.com/TinkrTech/nix-config .
        ```
6. Generate the hardware configuration
    ```sh
    mkdir -p hosts/HOSTNAME # Replace HOSTNAME with the chosen hostname
    sudo nixos-generate-config --root /mnt --dir /mnt/home/jade/nixos/hosts/HOSTNAME
    
    ```
7. Copy the template folder, replacing HOSTNAME with the new host's name 
    ```sh
    cp hosts/template hosts/HOSTNAME # replace HOSTNAME with the new hosts name
    ```
8. Modify `hosts/HOSTNAME/configuration.nix` and `hosts/HOSTNAME/home.nix` to have the machine configuration you want. 
    - Hint: Use `nix-shell -p vim` to temporarily install vim :D
    - Note: `modules/nixos/network.nix` requires copying the `/home/jade/.config/sops/age/private-keys-only.txt` file from an existing machine
9. Add the hostname to the hosts variable in `flake.nix`
10. Install nixos
    ```sh
    sudo nixos-install --flake .
    ```
11. Once the command exits correctly, reboot
    ```sh
    sudo reboot
    ```


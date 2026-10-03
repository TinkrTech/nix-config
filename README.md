# Nix-Config

This repo contains the configuration files for all NixOS machines.

# Creating a new host

## Prerequisites

1. NixOS installation media (Guide available on [nixos.org](https://nixos.org/download))
2. Choose a hostname - Following the theme, it should be a character in The Stormlight Archives
    - Hint: the commands can be copied here if you set the `HOST` environment variable
3. Create a new sops key on an existing host (e.g. lopen)
    1. Generate a new age private/public key pair
        ```sh
        nix shell nixpkgs#age -c age-keygen -o ~/keys.txt
        sed '/^#/d' ~/.config/sops/age/key
        nix shell nixpkgs#age -c age-keygen -y ~/keys.txt | xclip
        ```
    2. Copy the **public key** to .sops.yaml file as follows:
        ```yaml
        keys:
          # ...
          - &host age...
        creation_rules:
          - path_regex: secrets.yaml$
            key_groups:
              - age:
                # ...
                - *host
        ```
    3. Run
        ```sh
        sops updatekeys secrets.yaml
        ```
    4. Push the updates to git

## Installation

1. Boot into the NixOS Live installer
2. Partition & format the boot drive with GParted (available in the graphical ISO)
3. Mount the drives
    ```sh
    lsblk
    sudo mount <root partition> /mnt
    sudo mkdir -p /mnt/boot
    sudo mount <boot partition> /mnt/boot -o umask=0077
    sudo swapon <swap partition> # if applicable
    ```
4. Clone this Repo 
    ```sh
    git clone https://github.com/TinkrTech/nix-config.git ~/nixos
    cd nixos
    ```
5. Move the `keys.txt` file from the prerequisites to a USB drive and copy it to `~/.config/sops/age/keys.txt`
6. Create the new machine's initial configuration
    1. Copy the template folder, replacing HOSTNAME with the new host's name 
        ```sh
        mkdir -p hosts/"$HOST" 
        cp hosts/template hosts/HOSTNAME
        ```
    2. Modify `hosts/HOSTNAME/configuration.nix` and `hosts/HOSTNAME/home-<user>.nix` to have the machine configuration you want. 
        - Hint: Use `nix-shell -p vim` to temporarily install vim :D
7. Generate the hardware configuration
    ```sh
    sudo nixos-generate-config --root /mnt --dir ~/nixos/hosts/HOSTNAME
    git add .
    ```
8. Install nixos
    ```sh
    sudo nixos-install --flake .#"$HOST"
    ```
9. Copy the modified configuration to the user's home directory
    ```sh
    sudo mkdir -p /mnt/home/USER/.config/
    sudo cp -r ~/.config/sops /mnt/home/USER/.config/sops
    sudo cp -r ~/nixos /mnt/home/USER/nixos
    ```
10. Once the command exits correctly, reboot
    ```sh
    reboot
    ```
11. Once rebooted, create a GitHub ssh key
    1. Run
        ```sh
        ssh-keygen -f ~/.ssh/github -N ""
        ```
    2. Copy the contents of ~/.ssh/github.pub to your clipboard
    3. Navigate to [Github SSH Keys](https://github.com/settings/keys/ssh/new)
    4. Set the title to the hostname of the machine, keep the type as "Authentication Key", and paste your public key into the "key" section.
12. Push the changes to remote
    - Note: You may need to fix the permissions of the folder
    ```sh
    cd nixos
    git push
    ```

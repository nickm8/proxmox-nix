{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Enable flakes for future use
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Basic boot configuration
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # Typically for VMs
  };

  # Basic networking
  networking = {
    hostName = "nixos";
    useDHCP = true;  # Simpler networking setup
    firewall = {
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
      # Required for Tailscale
      checkReversePath = "loose";
    };
  };

  # Time and Locale
  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  # Enable Hyper-V guest services
  virtualisation.hypervGuest.enable = true;

  # Basic system packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core utilities
    wget
    vim
    git
    curl
    htop
    btop
    unzip
  ];

  # Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
      ports = [ 22 ];
    };

    tailscale.enable = true;
  };

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" "kubectl" ];
      theme = "robbyrussell";
    };
    shellInit = ''
      ${builtins.replaceStrings ["\r\n"] ["\n"] (builtins.readFile ./functions.zsh)}
      ${builtins.replaceStrings ["\r\n"] ["\n"] (builtins.readFile ./client-functions.zsh)}
    '';
  };

  # Sets ZSH as default shell
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.11";
}
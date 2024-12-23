{ config, pkgs, ... }:

{
  # Basic system settings
  networking = {
    networkmanager.enable = true;
    wireless.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # Time and locale settings
  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  # X11 configuration
  services.xserver = {
    layout = "au";
    variant = "";
  };

  # User configuration
  users.users.nixtest = {
    isNormalUser = true;
    description = "nixtest";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    git
    tailscale
  ];

  # SSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      X11Forwarding = false;
    };
    ports = [ 22 ];
  };

  # Enable Tailscale
  services.tailscale.enable = true;

  # System state version
  system.stateVersion = "24.11";
}
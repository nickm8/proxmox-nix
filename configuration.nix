{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  users.users.nixtest = {
    isNormalUser = true;
    description = "nixtest";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    tailscale
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      X11Forwarding = false;
    };
    ports = [ 22 ];
  };

  services.tailscale.enable = true;

  system.stateVersion = "24.11";
}
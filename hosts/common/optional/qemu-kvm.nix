{ config
, lib
, pkgs
, ...
}: {
  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtiofsd
  ];

  users.users.${config.hostSpec.username}.extraGroups = [ "libvirtd" ];

  services.spice-vdagentd.enable = true;
}

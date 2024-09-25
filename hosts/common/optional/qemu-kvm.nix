{ pkgs
, configVars
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
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    virtiofsd
    virt-viewer
    spice
    spice-gtk
    spice-protocol
  ];

  users.users.${configVars.username} = {
    extraGroups = [ "libvirtd" ];
  };

  services.spice-vdagentd.enable = true;
}

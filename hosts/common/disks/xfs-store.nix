{ device ? throw "example /dev/vdb", ... }: {
  disko.devices.disk.data = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions.data = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "xfs";
          mountpoint = "/data";
        };
      };
    };
  };
}

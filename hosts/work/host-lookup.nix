{pkgs, ...}:
pkgs.writePerl "host-lookup" {
  libraries = with pkgs.perlPackages; [
    pkgs.perl
    JSON
    LWP
    URI
    ListMoreUtils
    TextCSV
  ];
} ''
  use boolean;
  print "Howdy!\n" if true;
''

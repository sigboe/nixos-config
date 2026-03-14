{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "reolink-cli";
  version = "3a89a723c25b1ece2db4131b7fe695bf271bff14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "benwickham";
    repo = pname;
    rev = version;
    sha256 = "sha256-1U3N2IOZ7XcMUr6hsnNmnJGjaoxWbUfg2FAXKdt9NoI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];


  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  meta = with lib; {
    homepage = "https://github.com/benwickham/reolink-cli";
    description = "Command-line interface for controlling Reolink cameras";
    license = licenses.mit;
    mainProgram = "reolink";
  };
}

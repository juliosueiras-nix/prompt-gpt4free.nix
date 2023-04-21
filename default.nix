{ stdenv,
  callPackage,
  fetchFromGitHub,
  python38,
  python38Packages,
  curl,
  writeShellScriptBin,
  cacert,
  ...
}: 

let
  gpt4all = stdenv.mkDerivation {
    name = "gpt4all";
    src = fetchFromGitHub {
      owner = "xtekky";
      repo = "gpt4free";
      rev = "3c579964ad0a7f0311c29ea8efd365744b6fe8dd";
      sha256 = "smDi8GvoBhMNUvswDAfFT74pzY2xb3S1SuKAoq17euo=";
    };

    installPhase = ''
      mkdir -p $out
      cp ${./.}/prompt.py $out/
      cp -r phind $out/
    '';
  };

  curl-impersonate = callPackage ./pkgs/curl-impersonate {};
  curl_cffi = python38Packages.buildPythonPackage rec {
    pname = "curl_cffi";
    version = "0.5.5";
    src = python38Packages.fetchPypi {
      inherit pname version;
      sha256 = "25S40K1S87XFXTIiXCmoIZoZWS2IIHWWWniqnhoN6tE=";
    };

    buildInputs = [
      curl
      curl-impersonate.curl-impersonate-chrome
    ];

    propagatedBuildInputs = [
      python38Packages.cffi
    ];
    postInstall = ''
      cp ${cacert}/etc/ssl/certs/ca-bundle.crt $out/lib/python3.8/site-packages/curl_cffi/cacert.pem
    '';
  };
in writeShellScriptBin "prompt" ''
  ${python38.withPackages (p: [ curl_cffi ])}/bin/python ${gpt4all}/prompt.py "$1"
''

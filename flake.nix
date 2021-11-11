{
  description = "C++14 implementation of the TLS-1.3 standard";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    folly.url = "github:willruggiano/folly";
  };

  outputs = { self, nixpkgs, utils, folly }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in
      {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "fizz";
          src = ./.;
          nativeBuildInputs = with pkgs; [ cmake pkg-config ];
          buildInputs = with pkgs; [
            boost
            double-conversion
            fmt
            folly.defaultPackage."${system}"
            gflags
            glog
            gtest
            jemalloc
            openssl
            libevent
            libsodium
            zlib
            zstd
          ];

          cmakeFlags = [ "-S ../fizz" "-DBUILD_SHARED_LIBS=ON" "-DBUILD_TESTS=OFF" "-DBUILD_EXAMPLES=OFF" ];
          enableParallelBuilding = true;
          doCheck = false;
        };
      });
}

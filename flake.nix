{
  description = "Nix theRock Torch";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      # Select your target card (info: https://github.com/ROCm/TheRock/blob/main/RELEASES.md)
      target = "gfx1151";

      python-with-deps = pkgs.python313.withPackages (
        ps: with ps; [
          pip
        ]
      );

      install-torch-rocm = pkgs.writeShellScriptBin "install-torch-rocm" ''
        # This will install the latest torch build from theRock
        pip install --index-url https://rocm.nightlies.amd.com/v2/${target}/ torch torchaudio torchvision
      '';

      install-deps = pkgs.writeShellScriptBin "install-other-deps" ''
        # Add your custom dependencies here
        pip install lightning pandas matplotlib tensorboard ipykernel
      '';

    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";

        packages = [
          python-with-deps
          pkgs.libgcc
          pkgs.gccNGPackages_15.libatomic

          # Custom scripts
          install-torch-rocm
          install-deps
        ];

        shellHook = ''
          # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
          # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
          export PIP_PREFIX=$(pwd)/.pip_packages
          export PYTHONPATH="$PIP_PREFIX/${python-with-deps.sitePackages}:$PYTHONPATH"
          export PATH="$PIP_PREFIX/bin:$PATH"
          unset SOURCE_DATE_EPOCH

          if [ ! -f requirements.txt ]; then
            install-torch-rocm
            install-other-deps
            pip freeze > requirements.txt
          fi

          echo "Python environment ready!"
          echo
        '';
      };
    };
}

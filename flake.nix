{
  description = "NIXOS-Blueprint — reproducible multi-host NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      plasma-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      # ----------------------------------------------------------------------
      # PUBLIC CUSTOMIZATION
      #
      # These values are deliberately generic so the repository can be published.
      # Adjust them before using this configuration on a real machine.
      # ----------------------------------------------------------------------
      userName = "nixos";
      userDescription = "NixOS User";
      gitUserName = "Your Name";
      gitUserEmail = "you@example.com";

      timeZone = "Etc/UTC";
      defaultLocale = "en_US.UTF-8";
      keyboardLayout = "us";

      # Use `null` to keep automatic commit signing disabled.
      # To enable GPG, replace it with your full public key fingerprint.
      gpgPublicKeyFingerprint = null;

      pkgsFor = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # The flake configuration name is also the effective hostname.
      # This keeps `.#$(hostname)` valid by construction on every host.
      mkHost =
        hostName: hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;

          # `specialArgs` exposes identity/location values to NixOS modules without
          # scattering hard-coded values throughout the repository.
          specialArgs = {
            inherit userName userDescription timeZone defaultLocale keyboardLayout;
          };

          modules = [
            ./modules/system/default.nix
            hostModule

            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager

            {
              networking.hostName = hostName;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
              ];

              # Preserve conflicting local files when Home Manager takes ownership.
              # Existing backups are never overwritten silently.
              home-manager.backupFileExtension = "hm-backup";
              home-manager.overwriteBackup = false;

              home-manager.extraSpecialArgs = {
                inherit userName gitUserName gitUserEmail gpgPublicKeyFingerprint;
              };
              home-manager.users.${userName} = import ./modules/home/default.nix;
            }
          ];
        };
    in
    {
      # When renaming a host, keep the attribute, mkHost argument, and module path
      # consistent. On the first switch, use `--flake .#NEW_NAME` explicitly;
      # `.#$(hostname)` only works after the new hostname has been activated.
      nixosConfigurations = {
        desktop = mkHost "desktop" ./hosts/desktop/default.nix;
        laptop = mkHost "laptop" ./hosts/laptop/default.nix;
      };

      # `nix flake check` should validate the complete build of both hosts,
      # not merely a shallow evaluation of the outputs.
      checks.${system} = {
        "desktop-system" = self.nixosConfigurations.desktop.config.system.build.toplevel;
        "laptop-system" = self.nixosConfigurations.laptop.config.system.build.toplevel;
      };

      # Standalone Home Manager keeps only the shared user layer.
      homeConfigurations.${userName} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor;
        extraSpecialArgs = {
          inherit userName gitUserName gitUserEmail gpgPublicKeyFingerprint;
        };
        modules = [
          plasma-manager.homeModules.plasma-manager
          ./modules/home/default.nix

          # Keep the same conservative backup behavior when Home Manager is used
          # independently from NixOS.
          {
            home.backupFileExtension = "hm-backup";
            home.overwriteBackup = false;
          }
        ];
      };

      formatter.${system} = pkgsFor.nixfmt;

      devShells.${system} =
        let
          pkgs = pkgsFor;

          devPackages = with pkgs; [
            gcc
            gnumake
            cmake
            pkg-config
            ninja
            gdb
            valgrind
          ];

          runtimePackages = with pkgs; [
            openjdk21
            nodejs_22
            rustup
            go
          ];

          # `pkgs.cudaPackages` tracks the default CUDA toolkit from the pinned nixpkgs.
          # If a project requires a specific CUDA version, pin its package set there.
          # CUDA package names/layout can also change between nixpkgs releases.
          cudaDevPackages = with pkgs.cudaPackages; [
            cudatoolkit
            cuda_cudart
            libcublas
            libcufft
            libcurand
            libcusolver
            libcusparse
          ];

          # PyTorch from nixpkgs follows the package set's build options and may not
          # expose CUDA in every scenario. For projects that require specific CUDA
          # wheels, prefer managing PyTorch in the project's venv with uv.
          aiPackages = with pkgs; [
            llama-cpp
            python312Packages.torch
            python312Packages.transformers
            python312Packages.accelerate
          ];

          devopsPackages = with pkgs; [
            yq-go
            kubectl
            helm
            k9s
            stern
            kustomize
            terraform
          ];
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ hello ];

            shellHook = ''
              echo "Base environment - use a specific devShell when needed"
              echo ""
              echo "Available shells:"
              echo "  native   - C/C++ development"
              echo "  runtimes - Node/Go/Java/Rust"
              echo "  python   - Python/UV stack"
              echo "  ai       - ML/AI tooling + CUDA toolkit"
              echo "  devops   - Kubernetes tools"
              echo "  cuda     - CUDA development"
            '';
          };

          native = pkgs.mkShell {
            packages = devPackages;

            shellHook = ''
              echo "Native development environment"
              echo "GCC: $(gcc --version | head -n1)"
              echo "CMake: $(cmake --version | head -n1)"
              echo "Ninja: $(ninja --version)"
              echo "GDB: $(gdb --version | head -n1)"
              echo "Valgrind: $(valgrind --version)"
            '';
          };

          runtimes = pkgs.mkShell {
            packages = runtimePackages;

            shellHook = ''
              echo "Runtime development environment"
              echo "Node: $(node --version)"
              echo "Go: $(go version)"
              echo "Java: $(java --version 2>&1 | head -n1)"
              echo "Rust: $(rustc --version 2>/dev/null || echo 'rustup not configured')"
            '';
          };

          python = pkgs.mkShell {
            packages = with pkgs; [
              python312
              uv
              ruff
              pyright
              python312Packages.pytest
              python312Packages.ipython
            ];

            shellHook = ''
              echo "Python development environment"
              echo "Python: $(python --version)"
              echo "UV: $(uv --version)"
              echo "pytest: $(pytest --version 2>/dev/null | head -n1 || echo 'not installed')"
              echo "IPython: $(ipython --version 2>/dev/null || echo 'not installed')"

              if [ ! -d .venv ]; then
                echo ""
                echo "Creating Python virtual environment..."
                uv venv .venv --python python
              fi

              source .venv/bin/activate

              echo ""
              echo "Virtualenv: $VIRTUAL_ENV"
              echo "Python: $(python --version)"
            '';
          };

          ai = pkgs.mkShell {
            packages = aiPackages ++ cudaDevPackages;

            shellHook = ''
              export CUDA_HOME="${pkgs.cudaPackages.cudatoolkit}"
              export CUDA_PATH="${pkgs.cudaPackages.cudatoolkit}"
              export PATH="${pkgs.cudaPackages.cudatoolkit}/bin:$PATH"
              export LD_LIBRARY_PATH="${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.libcublas}/lib:$LD_LIBRARY_PATH"

              echo "AI / ML environment + CUDA toolkit"
              echo "CUDA:"
              nvcc --version | grep release || true
              echo ""

              if command -v llama-cli >/dev/null 2>&1; then
                echo "llama.cpp: available"
              fi

              if python -c "import torch" 2>/dev/null; then
                echo "PyTorch: $(python -c 'import torch; print(torch.__version__)')"
                if python -c "import torch, sys; sys.exit(0 if torch.cuda.is_available() else 1)" 2>/dev/null; then
                  echo "CUDA available"
                else
                  echo "PyTorch without CUDA - check the driver/toolkit or use a CUDA wheel in the project venv"
                fi
              fi
            '';
          };

          devops = pkgs.mkShell {
            packages = devopsPackages;

            shellHook = ''
              echo "DevOps environment"
              echo "kubectl: $(kubectl version --client 2>/dev/null | head -n1 || true)"
              echo "Helm: $(helm version --short 2>/dev/null || true)"
              echo "Terraform: $(terraform version 2>/dev/null | head -n1 || true)"
              echo ""

              if docker info >/dev/null 2>&1; then
                echo "Docker available"
              else
                echo "Docker unavailable or permission denied"
              fi

              echo "Docker is provided by the NixOS host."
            '';
          };

          cuda = pkgs.mkShell {
            packages = devPackages ++ cudaDevPackages;

            shellHook = ''
              export CUDA_HOME="${pkgs.cudaPackages.cudatoolkit}"
              export CUDA_PATH="${pkgs.cudaPackages.cudatoolkit}"
              export PATH="${pkgs.cudaPackages.cudatoolkit}/bin:$PATH"
              export LD_LIBRARY_PATH="${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.libcublas}/lib:$LD_LIBRARY_PATH"

              echo "CUDA development environment"
              nvcc --version | grep release || true
              echo ""
              echo "GPU:"
              nvidia-smi 2>/dev/null || echo "NVIDIA driver unavailable"
              echo ""
              echo "Compilation example:"
              echo "  nvcc -o test test.cu"
            '';
          };
        };
    };
}

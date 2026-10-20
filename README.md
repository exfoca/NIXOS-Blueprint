# NIXOS-Blueprint — your operating system as code

Your Linux system works. The problem appears when you need to **reproduce it**.

If your SSD dies tomorrow, can you rebuild the machine with the same packages, services, drivers, desktop, Git, SSH, Docker, and development tools — or do you start rebuilding a list of manual installations and tweaks?

NixOS starts from a simple idea: instead of configuring the computer and relying on memory later, you **describe the desired state in version-controlled files**.

This repository is a real-world example of that approach: two complete machines, a desktop and a laptop, sharing configuration without hiding their hardware differences.

> If you have never used NixOS, the goal here is not to provide a configuration to copy blindly. It is to show why the declarative model is worth trying.

## Why try NixOS?

| Situation | With a traditional configuration | With NixOS |
|---|---|---|
| Reinstall a machine | redo tweaks manually | reapply the configuration |
| Keep two computers similar | repeat changes | share modules |
| Find out what changed | inspect the current state | inspect the Git diff |
| Test a system change | modify the live system | build and test a new generation |
| Recover from a problematic update | fix or undo changes manually | roll back to an earlier generation |
| Prepare a development environment | install toolchains globally | enter it with `nix develop` |

The point is not merely to install packages differently. It is to make the computer **reproducible, auditable, and recoverable**.

Once the configuration works, it no longer exists only inside that installation. It becomes something you can understand, version, rebuild, and evolve.

## What this repository demonstrates

- a single flake managing multiple hosts;
- NixOS for system state;
- Home Manager for the user environment;
- KDE Plasma 6 + Wayland;
- NVIDIA as an opt-in capability;
- PRIME render offload on a hybrid laptop;
- NetworkManager, firewall, SSH, and Fail2ban;
- Docker, VirtualBox, AppImage, Steam, and Gamescope;
- declarative Flatpak management;
- Git, GPG, SSH, and VSCodium;
- dev shells for C/C++, Java, Node, Go, Rust, Python, AI/CUDA, and DevOps.

None of this has to exist on your machine. The advantage of the model is precisely that you can **add or remove capabilities in code**.

## You do not need to migrate your primary machine

Try it with low risk: use a VM or a secondary machine and treat this repository as a reference.

If you already use the Nix package manager on another Linux distribution, you can also explore the `devShells` without converting the host to NixOS.

The mental model is:

```text
manual configuration
        ↓
 describe the system
        ↓
   validate / build
        ↓
      activate
        ↓
 version it in Git
```

That shift — more than any specific package — is what makes NixOS worth trying.

## Architecture in 30 seconds

```text
.
├── flake.nix                  # host composition, inputs, and dev shells
├── flake.lock                 # exact input versions
├── modules/
│   ├── home/                  # shared user configuration
│   └── system/                # reusable services and capabilities
├── hosts/
│   ├── desktop/               # desktop hardware and decisions
│   └── laptop/                # laptop hardware and decisions
└── examples/                  # optional modules
```

The rule is simple:

- truly shared configuration belongs in `modules/`;
- reusable but non-universal capabilities can also live in `modules/` and be imported explicitly;
- hardware and concrete machine-specific differences remain in `hosts/`.

`modules/system/nvidia.nix` is the clearest example: the module exists as a reusable capability, but only NVIDIA hosts import it.

```text
flake.nix
   │
   ├── desktop ──> hosts/desktop/default.nix
   │               ├── hardware-configuration.nix
   │               ├── wifi.nix
   │               ├── plasma.nix
   │               └── nvidia.nix (opt-in)
   │
   ├── laptop ───> hosts/laptop/default.nix
   │               ├── hardware-configuration.nix
   │               ├── plasma.nix
   │               ├── prime.nix
   │               └── nvidia.nix (opt-in)
   │
   └── both ─────> modules/system/default.nix
                   └── Home Manager -> modules/home/default.nix
```

## The workflow

After adapting the host configuration to the hardware, changing the system usually means editing files and running:

```bash
nix fmt
nix flake check
sudo nixos-rebuild test --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
```

`test` activates the new configuration without making it the default boot generation. `switch` makes the current generation persistent.

NixOS keeps previous generations. If a change causes problems, you still have a path back — including from the boot menu.

This is one of the most noticeable differences for anyone used to updating a system directly on top of its current state.

## Getting started with this repository

> **Warning:** this repository was sanitized for publication. Identity, disks, keys, and location use example values. The `hardware-configuration.nix` files do not represent your machine.

The example hosts assume UEFI/systemd-boot, KDE Plasma 6, and NVIDIA GPUs. Docker, VirtualBox, gaming, and SSH are also enabled because they were part of the machines that inspired this configuration. Remove anything that does not make sense for your setup.

### 1. Clone or fork the repository

```bash
git clone <YOUR-FORK-URL> ~/NIXOS-Blueprint
cd ~/NIXOS-Blueprint
```

The aliases use `~/NIXOS-Blueprint` by default. For a different path:

```bash
export NIXOS_DOTFILES="$HOME/path/to/repository"
```

### 2. Customize the `PUBLIC CUSTOMIZATION` block

Near the top of `flake.nix`:

```nix
userName = "nixos";
userDescription = "NixOS User";
gitUserName = "Your Name";
gitUserEmail = "you@example.com";

timeZone = "Etc/UTC";
defaultLocale = "en_US.UTF-8";
keyboardLayout = "us";

gpgPublicKeyFingerprint = null;
```

The fingerprint can remain `null`. Never commit private keys or other secrets to Git.

### 3. Choose your host

The current examples are:

- `desktop` — AMD + NVIDIA workstation;
- `laptop` — Intel + NVIDIA laptop with PRIME offload.

You can copy one and rename it. Keep the attribute in `nixosConfigurations`, the `mkHost` argument, and the directory under `hosts/` consistent:

```nix
nixosConfigurations = {
  myhost = mkHost "myhost" ./hosts/myhost/default.nix;
};
```

For the first switch, use the name explicitly:

```bash
sudo nixos-rebuild switch --flake .#myhost
```

After the hostname is active, `.#$(hostname)` can also be used.

### 4. Generate the real hardware configuration

The files in the repository are sanitized placeholders. Generate the file on the target machine:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
```

or:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
```

Review `/`, `/boot`, swap, LUKS, kernel modules, and microcode.

The examples use the labels `NIXOS_ROOT`, `NIXOS_BOOT`, and `NIXOS_SWAP`. If `lsblk -f` does not show those labels, do not boot using the sanitized files without regenerating or adapting them first.

### 5. Remove hardware-specific example configuration

- `hosts/desktop/wifi.nix` — MediaTek MT7921K/RZ608;
- `hosts/laptop/prime.nix` — example Intel + NVIDIA bus IDs;
- `modules/system/nvidia.nix` — NVIDIA hosts only;
- `hosts/desktop/default.nix` — `aarch64-linux` emulation through QEMU/binfmt.

To inspect the machine:

```bash
lspci -nn
lsusb
lsblk -f
```

AMD/Intel-only machines simply should not import `modules/system/nvidia.nix`.

## Home Manager: your user environment also becomes code

Home Manager applies the same declarative idea to the user layer. In this example it manages Bash, Git, GPG, SSH, VSCodium, Plasma, and CLI tools.

The flake also exposes a standalone Home Manager configuration:

```bash
home-manager switch --flake .#nixos
```

If you change `userName`, use the new name after `.#`.

## Dev shells: try one of the best ideas in the Nix ecosystem

Instead of installing every tool globally, enter the environment you need:

```bash
nix develop .#native
nix develop .#runtimes
nix develop .#python
nix develop .#ai
nix develop .#devops
nix develop .#cuda
```

The shells cover:

- C/C++ — GCC, CMake, Ninja, GDB, Valgrind;
- runtimes — Java, Node.js, Go, Rust;
- Python — Python, uv, Ruff, Pyright, pytest, IPython;
- AI — llama.cpp, PyTorch, Transformers, Accelerate, CUDA;
- DevOps — kubectl, Helm, k9s, Stern, Kustomize, Terraform;
- CUDA — NVIDIA toolchain and utilities.

The `ai` and `cuda` shells assume compatible NVIDIA hardware and drivers. Projects that require a specific CUDA build of PyTorch should keep that decision inside the project itself, for example in a `.venv` managed with `uv`.

## Flatpak: minimal by default

`modules/system/flatpak.nix` installs only a small set of applications.

A larger catalog is available in:

```text
examples/flatpak-extra.nix
```

It is not imported by default. This prevents the first `switch` from turning into a large download of runtimes and applications you may not even want.

`services.flatpak.packages` is provided by the `nix-flatpak` input used by this flake.

## Pinned release and `stateVersion`

This snapshot uses NixOS/Home Manager **26.05** and keeps the exact resolution in `flake.lock`.

When moving to a new release, update the inputs deliberately. Do not change `system.stateVersion` or `home.stateVersion` merely because you updated the system: those values control state compatibility and normally remain at the version used when the installation was created.

The CUDA shells use the `pkgs.cudaPackages` selected by the pinned Nixpkgs. Projects that require an exact CUDA version should pin it in the project itself.

## SSH and GPG

The SSH client expects `~/.ssh/id_ed25519`. Generate your key locally:

```bash
ssh-keygen -t ed25519 -a 64
```

For remote login, add only the **public** key to the host:

```nix
users.users.${userName}.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAA... comment"
];
```

The example SSH server disables password and `root` login, restricts access to the primary user, and uses Fail2ban.

Git signing with GPG is optional. Only the public fingerprint belongs in the configuration; the private key remains in the local keyring.

## Security and privileges

This is a workstation example, not a universal security baseline:

- the primary user belongs to `wheel`, `docker`, and `vboxusers`;
- `sudo` requires a password;
- access to the Docker socket is effectively equivalent to root privileges;
- the `nofile` tuning uses `domain = "*"` and applies globally to users covered by PAM;
- Steam Remote Play opens firewall ports;
- VSCodium Workspace Trust remains enabled;
- Home Manager creates `.hm-backup` files without silently overwriting them.

If you do not use Docker, VirtualBox, gaming, SSH, or another capability, remove the corresponding module and groups.

## Validate before activation

```bash
nix fmt
nix flake check
```

The checks build `system.build.toplevel` for both hosts.

For a single host:

```bash
nix build --no-link .#nixosConfigurations.desktop.config.system.build.toplevel
```

Before making a change persistent:

```bash
sudo nixos-rebuild dry-build --flake .#desktop
sudo nixos-rebuild test --flake .#desktop
```

Then:

```bash
sudo nixos-rebuild switch --flake .#desktop
```

## Before publishing your fork

Search for credentials and personal identifiers:

```bash
rg -n -i 'password|passwd|secret|token|api[_-]?key|ssh-(rsa|ed25519)|BEGIN .*PRIVATE KEY'
rg -n -i 'id_(rsa|ed25519|ecdsa|dsa)|\.(pem|p12|pfx|gpg|age|kdbx)$'
rg -n '/dev/disk/by-uuid|/dev/mapper/luks|/home/'
rg -n -i 'email|fingerprint|github|gitlab|bitbucket'
```

These searches produce false positives. Review the matches; do not delete lines blindly.

## The idea worth taking away

NixOS changes the question.

Instead of:

> “How do I configure this computer?”

you begin to ask:

> “How do I describe this computer so I can rebuild it later?”

That difference seems abstract until you replace a machine, break an update, manage several computers, or try to remember why a system configured two years ago works the way it does.

When that problem starts to matter, NixOS stops looking like “just another Linux distribution” and starts looking like a very logical solution.

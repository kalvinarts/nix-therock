# Nix theRock Torch

A nix dev shell with AMD ROCm “TheRock” nightly PyTorch builds

This repository provides a template Python environment with the latest ROCm-enabled `torch`, `torchaudio`, and `torchvision` from AMD’s nightly index.

## Index

- [Why a nix shell instead of a container](#why-a-nix-shell-instead-of-a-container)
- [Prerequisites](#prerequisites)
- [Select your target GPU](#select-your-target-gpu)
- [Add your own dependencies](#add-your-own-dependencies)
- [Quick start](#quick-start)
- [Managing Python Packages](#managing-python-packages)
- [Common Commands](#common-commands)
- [Notes](#notes)

## Why a nix shell instead of a container

- **Performance:** A nix shell lot faster (up to 2x depending on what are you training).
- **Integration with your editor:** Spawn your editor inside the shell and package detection will work out of the box.
- **Contained dev environment:** Add any dependencies you can think of, either from PyPI or Nixpkgs to the `flake.nix` and they will be available in your shell.
- **Portability and management:** A nix shell can be run on any system with Nix installed, making it easy to share your environment with others, without having to rebuild and upload images.

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled (you don't need to be on NixOS to use Nix)

NOTE: For now this setup expects your system to be any x86_64 linux but it may work on Windows (untested) if you change the system architecture in `flake.nix`. Let me know if you test it and it works!

## Select your target GPU

Set the target GPU in `flake.nix` (default is Strix Halo):

```nix
target = "gfx1151";
```

If you have a different AMD GPU, change this value to the matching ROCm target listed in the [TheRock releases section](https://github.com/ROCm/TheRock/blob/main/RELEASES.md).

## Add your own dependencies

Edit the `install-deps` script in `flake.nix` to add/remove dependencies.

## Quick start

1. Clone the repository and enter the project directory:
   ```sh
   git clone https://github.com/kalvinarts/nix-therock.git your-project-name
   cd your-project-name
   ```

2. Enter the dev shell:
   ```sh
   nix develop
   ```

3. On first entry, the shell will:
   - Configure `PIP_PREFIX` to `./.pip_packages`
   - Install ROCm nightly PyTorch builds
   - Install extra dependencies
   - Write `requirements.txt`

You should see:

```
Python environment ready!
```

## Managing Python Packages

Inside the shell you are effectively in a Python environment with `PIP_PREFIX` set to `./.pip_packages` and your `PATH` is extended with `./.pip_packages/bin`.

- Add more packages in the `install-deps` script in `flake.nix`.
- Manually run `pip install <package_name>` inside the shell
- Re-generate requirements with `pip freeze > requirements.txt` as needed.

## Common Commands

- Enter the dev shell:
  ```sh
  nix develop
  ```

- Or if you want to use another shell different than bash (e.g. zsh)
  ```sh
  nix develop -c zsh
  ```

Inside the dev shell you have some extra commands you can use:

- Reinstall Torch from ROCm nightly
  ```sh
  install-torch-rocm
  ```

- Install your extra dependencies
  ```sh
  install-deps
  ```

- You can also run the commands provided from the project python dependencies like `rocminfo`, `rocm-smi` etc...


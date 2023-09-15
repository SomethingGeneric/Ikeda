# MOVED TO https://git.tar.black/ikeda/Ikeda


# ![](ikeda-icon.png) Ikeda
Ikeda is a WIP BusyBox and musl-libc based Linux System

![](ikeda.png)

## Common Build dependencies
- `bc`
- `git`
- `musl`
- `elfutils`
- `flex`
- `cmake`
- `qemu`
- `wget`
- `openssl`
- `gparted` or `parted` ?

## Build Dependencies (for void or arch)
- `base-devel`

## Build Dependencies (Pop!_OS)
- `build-essential`
- `qemu-system`
- `bison`
- `libssl-dev`
- `libelf-dev`
- `musl-tools`
- `grub-pc` since Pop uses SystemD-boot (but Ubuntu shouldn't need this?)

Note: some distros will also require you to install `foo-devel`, `foo-dev`, or `libfoo` variants of certain packages. 

## General build:
- `./build.sh`

## Script notes:
- Script will download and compile bits as needed
 - To force a re-compile of Linux, delete `work/linux-${kernel_version}/arch/x86_64/boot/bzImage`
 - To force a re-compile of BuxyBox, delete `work/busybox-${busybox_version}/busybox`
 - To force a re-compile of Bash, delete `work/bash-${bash_version}/out/bin/bash`
 - To force a re-compile of MUSL toolchain, delete `work/musl-out`
 - Alternatively, run `./clean.sh` to force rebuild and reclones of everything.
- Use `./build.sh test -ng` to run qemu in TTY, rather than X/Wayland

## Why the name?
https://en.wikipedia.org/wiki/Ikeda_map

## Sources:
- Toolchain
  
  https://github.com/MichielDerhaeg/build-linux
- Musl libc
  
  https://www.musl-libc.org/
- ZSH Project

  https://sourceforge.net/p/zsh/code/ci/master/tree/
- Our ZSH binary

  https://github.com/romkatv/zsh-bin

## Notes:

#### BusyBox

Derhaeg's original BusyBox config was taken from Arch Linux, if any issues arise we can attempt to use Arch Linux's latest BusyBox config in its place.


# This project has moved:
[GitLab Repository](https://gitlab.mattcompton.dev/matt/Ikeda)

# This project has moved:
[GitLab Repository](https://gitlab.mattcompton.dev/matt/Ikeda)
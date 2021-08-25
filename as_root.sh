#!/bin/bash

cores=$(nproc)

kernel_version=$(cat linux-version)
busybox_version=$(cat busybox-version)
bash_version=$(cat bash-version)

base=$(pwd)

tgt=$(losetup -P -f --show ikeda)
mkdir ikeda_mount
mkfs.ext4 ${tgt}p1
mount ${tgt}p1 ikeda_mount

echo "Making raw filesystem"

pushd ikeda_mount

mkdir -p usr/{sbin,bin} bin sbin boot
mkdir -p {dev,etc,home,lib,mnt,opt,proc,srv,sys,run}
mkdir -p var/{lib,lock,log,run,spool,cache}
install -d -m 0750 root
install -d -m 1777 tmp
mkdir -p usr/{include,lib,share,src,local}

ln -s bin/bash usr/bin/zsh

echo "Copying linux-${kernel_version} and busybox-${busybox_version}"
cp ../linux-${kernel_version}/arch/x86_64/boot/bzImage boot/bzImage
cp ../busybox-${busybox_version}/busybox usr/bin/busybox
for util in $(./usr/bin/busybox --list-full); do
    ln -s /usr/bin/busybox $util
done
mkdir -p usr/share/udhcpc
cp -rv ../busybox-${busybox_version}/examples/udhcp/* usr/share/udhcpc/.

echo "Installing musl-${musl_version} . . ."
cp -r ../musl-out/* usr/.

echo "Installing bash-${bash_version} . . ."
cp -rv ../bash-${bash_version}/out/* usr/.

echo "Unpacking statically prebuilt zsh . . ."
pushd usr
curl -LO https://github.com/romkatv/zsh-bin/releases/download/v6.0.0/zsh-5.8-linux-x86_64.tar.gz
tar -xf zsh-5.8-linux-x86_64.tar.gz
rm zsh-5.8-linux-x86_64.tar.gz
popd

echo "Installing GRUB"
grub-install --modules=part_msdos --target=i386-pc --boot-directory="$PWD/boot" ${tgt} 
partuuid=$(fdisk -l ../ikeda | grep "Disk identifier" | awk '{split($0,a,": "); print a[2]}' | sed 's/0x//g')
mkdir -p boot/grub
echo "linux /boot/bzImage quiet root=PARTUUID=${partuuid}-01" > boot/grub/grub.cfg 
echo "boot" >> boot/grub/grub.cfg

popd

echo "Final filesystem setup"
cp -r filesystem/* ikeda_mount/.
chmod -R -x ikeda_mount/etc/*
chmod -R +x ikeda_mount/etc/init.d/*

printf "Would you like a RootFS tarball? (y/N): "
read RFS

if [[ "$RFS" == "y" ]]; then
    rm ikeda.tar.gz
    pushd ikeda_mount && tar -czf ../ikeda.tar.gz * && popd
fi

umount -v ikeda_mount
rm -rf ikeda_mount

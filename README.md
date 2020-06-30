```bash
apt install wget git devscripts libproc-processtable-perl dkms
mkdir -p /usr/local/src/media-build
cd /usr/local/src/media-build
git clone https://github.com/mnival/media-build-create-tar-dkms.git
cd media-build-create-tar-dkms
KERNEL_VERSION=5.7
./create_dkms_tar.sh patch ${KERNEL_VERSION}
cd ..
git clone https://github.com/jasmin-j/media-build-dkms
cd media-build-dkms
cp -p $(ls -1t ../media-build-${KERNEL_VERSION}-$(date +"%Y%m%d").*.dkms_src.tgz) .
./prepare_dkms_src.sh Debian
dch
fakeroot debian/rules binary
debuild -i -us -uc -S
debuild -i -us -uc -b
dpkg -i ../media-build-dkms_${KERNEL_VERSION}-$(date +"%Y%m%d").*_all.deb
```

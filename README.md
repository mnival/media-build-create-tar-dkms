`apt install wget curl git devscripts libproc-processtable-perl dkms
mkdir -p /usr/local/src/media-build
cd /usr/local/src/media-build
git clone https://github.com/mnival/media-build-create-tar-dkms.git
cd media-build-create-tar-dkms
./create_dkms_tar.sh patch
cd ..
git clone https://github.com/jasmin-j/media-build-dkms
cd media-build-dkms
cp -p $(ls -1t ../media-build-$(date +"%Y%m%d").*.dkms_src.tgz) .
./prepare_dkms_src.sh Debian
fakeroot debian/rules binary; debuild -i -us -uc -S; debuild -i -us -uc -b`

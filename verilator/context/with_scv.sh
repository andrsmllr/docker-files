# Get SystemC verification components, optional

SCV=scv-2.0.1
INSTALL_PATH=/opt/${SCV}

wget https://www.accellera.org/images/downloads/standards/systemc/${SCV}.tar.gz
tar xf ${SCV}.tar.gz

cd ${WORK_DIR}/${SCV}
./configure --prefix=${INSTALL_PATH}
make -j$(nproc)
make install
#make check

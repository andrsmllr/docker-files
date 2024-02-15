# Get SystemC sources, optional

SYSTEMC=systemc-2.3.3
INSTALL_PATH=/opt/${SYSTEMC}

wget https://www.accellera.org/images/downloads/standards/systemc/${SYSTEMC}.tar.gz
tar xf ${SYSTEMC}.tar.gz

cd ${SYSTEMC}
./configure --prefix=${INSTALL_PATH}

make -j$(nproc)
make install
#make check

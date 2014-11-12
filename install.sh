#!/bin/bash

if [ "$1" == "clean" ]; then
    cd kitlus
    make clean
    cd ../agents
    make clean
fi

cd kitlus
make -j install

cd ../agents
make -j install

cd ..

echo ""
echo "** You might need to add '$HOME/.local/lib' to your LD_LIBRARY_PATH."
echo ""

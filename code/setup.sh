##1
snarkjs powersoftau new bn128 14 pot14_0000.ptau -v && \
##2
snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First && \contribution" -v -e="some random text"
##3
snarkjs powersoftau contribute pot14_0001.ptau pot14_0002.ptau --name="Second contribution" -v -e="some random text" && \
##4
snarkjs powersoftau export challenge pot14_0002.ptau challenge_0003 && \
snarkjs powersoftau challenge contribute bn128 challenge_0003 response_0003 -e="some random text" && \
snarkjs powersoftau import response pot14_0002.ptau response_0003 pot14_0003.ptau -n="Third contribution name" && \
##5
snarkjs powersoftau verify pot14_0003.ptau && \
##6
snarkjs powersoftau beacon pot14_0003.ptau pot14_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon" && \
##7
snarkjs powersoftau prepare phase2 pot14_beacon.ptau pot14_final.ptau -v && \
##8
snarkjs powersoftau verify pot14_final.ptau


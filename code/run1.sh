## number of constraints
## 25888

##1
snarkjs powersoftau new bn128 15 pot14_0000.ptau -v && \
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
snarkjs powersoftau verify pot14_final.ptau && \
##9
##Create the circuit
##10
circom --r1cs --wasm --c --sym --inspect /home/y.okura/zkp/code/circuit1.circom && \
##11
snarkjs r1cs info circuit1.r1cs && \
##12
snarkjs r1cs print circuit1.r1cs circuit1.sym && \
##13
snarkjs r1cs export json circuit1.r1cs circuit1.r1cs.json && \
cat circuit1.r1cs.json && \
##14
##Calculate the witness
snarkjs wtns calculate circuit1_js/circuit1.wasm  /home/y.okura/zkp/code/input1.json witness.wtns && \
snarkjs wtns check circuit1.r1cs witness.wtns && \
##15
snarkjs groth16 setup circuit1.r1cs pot14_final.ptau circuit1_0000.zkey && \
##16
snarkjs zkey contribute circuit1_0000.zkey circuit1_0001.zkey --name="1st Contributor Name" -v  -e="some random text" && \
##17
snarkjs zkey contribute circuit1_0001.zkey circuit1_0002.zkey --name="Second contribution Name" -v -e="Another random entropy" && \
##18
snarkjs zkey export bellman circuit1_0002.zkey  challenge_phase2_0003 && \
snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text" && \
snarkjs zkey import bellman circuit1_0002.zkey response_phase2_0003 circuit1_0003.zkey -n="Third contribution name" && \
##19
snarkjs zkey verify circuit1.r1cs pot14_final.ptau circuit1_0003.zkey && \
##20
snarkjs zkey beacon circuit1_0003.zkey circuit1_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2" && \
##21
snarkjs zkey verify circuit1.r1cs pot14_final.ptau circuit1_final.zkey && \
##22
snarkjs zkey export verificationkey circuit1_final.zkey verification_key.json && \
##23
snarkjs groth16 prove circuit1_final.zkey witness.wtns proof.json public.json && \
##23a
snarkjs groth16 fullprove  /home/y.okura/zkp/code/input1.json circuit1_js/circuit1.wasm circuit1_final.zkey proof.json public.json && \
##24
snarkjs groth16 verify verification_key.json public.json proof.json && \
##25
cat public.json


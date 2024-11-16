## number of constraints
## 32950
##Create the circuit
##10
circom --r1cs --wasm --c --sym --inspect /home/y.okura/zkp/code/circuit3.circom && \
##11
snarkjs r1cs info circuit3.r1cs && \
##12
snarkjs r1cs print circuit3.r1cs circuit3.sym && \
##13
snarkjs r1cs export json circuit3.r1cs circuit3.r1cs.json && \
cat circuit3.r1cs.json && \
##14
##Calculate the witness
snarkjs wtns calculate circuit3_js/circuit2.wasm  /home/y.okura/zkp/code/input1.json witness.wtns && \
snarkjs wtns check circuit3.r1cs witness.wtns && \
##15
snarkjs groth16 setup circuit3.r1cs /mnt/mp_nas_mks/yuki_data/powersOfTau28_hez_final_15.ptau circuit3_0000.zkey && \
##16
snarkjs zkey contribute circuit3_0000.zkey circuit3_0001.zkey --name="1st Contributor Name" -v  -e="some random text" && \
##17
snarkjs zkey contribute circuit3_0001.zkey circuit3_0002.zkey --name="Second contribution Name" -v -e="Another random entropy" && \
##18
snarkjs zkey export bellman circuit3_0002.zkey  challenge_phase2_0003 && \
snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text" && \
snarkjs zkey import bellman circuit3_0002.zkey response_phase2_0003 circuit3_0003.zkey -n="Third contribution name" && \
##19
snarkjs zkey verify circuit3.r1cs /mnt/mp_nas_mks/yuki_data/powersOfTau28_hez_final_15.ptau circuit3_0003.zkey && \
##20
snarkjs zkey beacon circuit3_0003.zkey circuit3_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2" && \
##21
snarkjs zkey verify circuit3.r1cs pot14_final.ptau circuit3_final.zkey && \
##22
snarkjs zkey export verificationkey circuit3_final.zkey verification_key.json && \
##23
snarkjs groth16 prove circuit3_final.zkey witness.wtns proof.json public.json && \
##23a
snarkjs groth16 fullprove  /home/y.okura/zkp/code/input1.json circuit3_js/circuit2.wasm circuit3_final.zkey proof.json public.json && \
##24
snarkjs groth16 verify verification_key.json public.json proof.json && \
##25
cat public.json


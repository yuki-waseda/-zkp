## number of constraints
## 24172

## Phase 1 セットアップ
snarkjs powersoftau new bn128 15 pot14_0000.ptau -v && \

## 100人の参加者がランダム性を追加
for i in $(seq 1 100); do
    prev=$(printf "pot14_%04d.ptau" $((i-1))) # 前のファイル名
    next=$(printf "pot14_%04d.ptau" $i)       # 次のファイル名
    snarkjs powersoftau contribute $prev $next --name="Participant $i" -v -e="random entropy for participant $i"
done && \

## 検証
snarkjs powersoftau verify pot14_0100.ptau && \

## ビーコン（最後のランダム性追加）
snarkjs powersoftau beacon pot14_0100.ptau pot14_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon" && \

## Phase 2 セットアップ
snarkjs powersoftau prepare phase2 pot14_beacon.ptau pot14_final.ptau -v && \
snarkjs powersoftau verify pot14_final.ptau && \

## 回路の作成とコンパイル
circom --r1cs --wasm --c --sym --inspect /home/y.okura/zkp/code/circuit3.circom && \
snarkjs r1cs info circuit3.r1cs && \
snarkjs r1cs print circuit3.r1cs circuit3.sym && \
snarkjs r1cs export json circuit3.r1cs circuit3.r1cs.json && \
cat circuit3.r1cs.json && \

## ウィットネスの計算
snarkjs wtns calculate circuit3_js/circuit3.wasm /home/y.okura/zkp/code/input1.json witness.wtns && \
snarkjs wtns check circuit3.r1cs witness.wtns && \

## Groth16 セットアップ
snarkjs groth16 setup circuit3.r1cs pot14_final.ptau circuit3_0000.zkey && \

## Phase 2 セレモニー (100人のランダム性追加)
for i in $(seq 1 100); do
    prev=$(printf "circuit3_%04d.zkey" $((i-1))) # 前のファイル名
    next=$(printf "circuit3_%04d.zkey" $i)       # 次のファイル名
    snarkjs zkey contribute $prev $next --name="Phase 2 Participant $i" -v -e="random entropy for Phase 2 participant $i"
done && \

## 検証とビーコン
snarkjs zkey verify circuit3.r1cs pot14_final.ptau circuit3_0100.zkey && \
snarkjs zkey beacon circuit3_0100.zkey circuit3_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2" && \
snarkjs zkey verify circuit3.r1cs pot14_final.ptau circuit3_final.zkey && \
snarkjs zkey export verificationkey circuit3_final.zkey verification_key.json && \

## 証明と検証
snarkjs groth16 prove circuit3_final.zkey witness.wtns proof.json public.json && \
snarkjs groth16 fullprove /home/y.okura/zkp/code/input1.json circuit3_js/circuit3.wasm circuit3_final.zkey proof.json public.json && \
snarkjs groth16 verify verification_key.json public.json proof.json && \

## 公開データの表示
cat public.json

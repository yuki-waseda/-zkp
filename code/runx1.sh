#!/bin/bash

# 実行時間の計測用関数
measure_time() {
    local start_time=$(date +%s%3N) # ミリ秒単位の開始時間
    output=$($1)                    # コマンドの実行結果を変数に格納
    local end_time=$(date +%s%3N)   # ミリ秒単位の終了時間
    local elapsed_time=$((end_time - start_time))
    echo "$elapsed_time"            # 実行時間を返す
}

# 各コマンドの実行回数
repeats=5

# コマンド23a: fullprove
cmd23a="snarkjs groth16 fullprove /home/y.okura/zkp/code/input1.json circuit1_js/circuit1.wasm circuit1_final.zkey proof.json public.json"

# コマンド24: verify
cmd24="snarkjs groth16 verify verification_key.json public.json proof.json"

# 実行時間の合計
total_time_23a=0
total_time_24=0

# コマンド23aの実行
echo "Running command 23a ($repeats times)..."
for i in $(seq 1 $repeats); do
    time_23a=$(measure_time "$cmd23a")
    echo "Run $i (23a): $time_23a ms"
    total_time_23a=$((total_time_23a + time_23a))
done

# コマンド24の実行
echo "Running command 24 ($repeats times)..."
for i in $(seq 1 $repeats); do
    time_24=$(measure_time "$cmd24" | tail -n 1) # 最後の行（実行時間）だけ取得
    echo "Run $i (24): $time_24 ms"
    total_time_24=$((total_time_24 + time_24))
done

# 平均時間の計算
average_time_23a=$((total_time_23a / repeats))
average_time_24=$((total_time_24 / repeats))

# 結果の表示
echo "Average execution time for command 23a: $average_time_23a ms"
echo "Average execution time for command 24: $average_time_24 ms"

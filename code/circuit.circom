pragma circom 2.1.6;

include "/home/y.okura/zkp/circomlib/circuits/poseidon.circom";

template Example () {
    signal input a;
    signal input b;
    signal output c;
    
    var unused = 4;

    component hash = Poseidon(2);
    hash.inputs[0] <== a;
    hash.inputs[1] <== b;

    c <== hash.out;
}

component main { public [ a,b ] } = Example();

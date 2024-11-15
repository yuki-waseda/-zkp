
pragma circom 2.1.6;
include "circomlib/poseidon.circom";
include "circomlib/bitify.circom";
include "circomlib/eddsaposeidon.circom";


// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";


template Main (out_dim, in_dim, S_clip, sigma) {
  signal input W_delta[out_dim][in_dim];
  signal input challenge; //チャレンジの値
  signal input R8[2];
  signal input S;
  signal input pk[2];

  var W_norm = 0;
  for(var i = 0; i < out_dim; i++){
      for(var j = 0; j < in_dim; j++){
          W_norm += W_delta[i][j];
      }
  }
  assert(W_norm < S_clip);


   component eddsaVerifier = EdDSAPoseidonVerifier();
    eddsaVerifier.Ax <== pk[0];
   eddsaVerifier.Ay <== pk[1];
   eddsaVerifier.S <== S;
   eddsaVerifier.R8x <== R8[0];
   eddsaVerifier.R8y <== R8[1];
   eddsaVerifier.M <== challenge;
   eddsaVerifier.enabled <== 1;
  
   var num_iterations = 2;
   component hash[out_dim][in_dim][num_iterations];
   component bitify[out_dim][in_dim][num_iterations];

   for(var i = 0; i < out_dim; i++){
      for(var j = 0; j < in_dim; j++){
          for(var k = 0; k < num_iterations; k++){
           hash[i][j][k]=Poseidon(5);
           bitify[i][j][k]= Num2Bits_strict();
           hash[i][j][k].inputs[0] <== R8[0];
           hash[i][j][k].inputs[1] <== R8[1];
           hash[i][j][k].inputs[2] <== S;
           hash[i][j][k].inputs[3] <== i * out_dim + j;
           hash[i][j][k].inputs[4] <== k;
           bitify[i][j][k].in <== hash[i][j][k].out;
          }
      }
   }
   var hash_len = 254;
   var randSeq[out_dim][in_dim][hash_len * num_iterations];
   for(var i =0; i < out_dim; i++){
       for(var j = 0; j < in_dim; j++){
           for(var k =0; k < num_iterations; k++){
               for(var l =0; l < hash_len; l++){
                   randSeq[i][j][k * hash_len + l] = bitify[i][j][k].out[l];
               }
           }
       }
   }
   var binom_val[out_dim][in_dim];

   for(var i =0; i < out_dim; i++){
       for(var j = 0; j < in_dim; j++){
           for(var k = 0; k < hash_len * num_iterations; k++){
                binom_val[i][j] += randSeq[i][j][k];
           }
       }
   }

   var noize[out_dim][in_dim];
   var binom_mean = hash_len * num_iterations; //(254 * num_iterations /2)
       binom_mean /= 2;
   var binom_deviation = 79687; 
   for(var i =0; i < out_dim; i++){
       for(var j = 0; j < in_dim; j++){
           noize[i][j] = binom_val[i][j] - binom_mean;
       }
   }

   signal output W_noised[out_dim][in_dim];
   for(var i =0; i < out_dim; i++){
       for(var j = 0; j < in_dim; j++){
           noize[i][j] *= S_clip;
           noize[i][j] *= sigma;
           W_noised[i][j] <== W_delta[i][j]* binom_deviation + noize[i][j];
       }
   }

}




component main {public [ challenge,pk ] } = Main(2,3,80000,10000);


/*
INPUT = {
"W_delta":[
    [10000,10000,10000],
    [10000,10000,10000]
],
"challenge":"77709350291488122190439405240929087353217064205896907018783839224649743200000",
"R8":[
    "16774387237116105358351138691924953050016913368559223093104495652194631946657",
    "4236017229338829513500649111148409967689382747836787517597021937816281861176"
    ],
"S":"402445995503813372065504427382289167600771739054294986315426548248231362557",
"pk":
    "11437843048345844185793707486483516383500921838036729863808043804720622959984",
    "11024656439251449463892509008176740830119252482644847515994325191124994607993"
]
} */



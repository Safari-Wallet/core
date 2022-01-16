//
//  File.swift
//  
//
//  Created by Ronald Mannak on 1/12/22.
//

import Foundation
import MEWwalletKit


/// <#Description#>
class Tx: ObservableObject {
    
    var transaction: EIP1559Transaction
    
    
    init(tx: EIP1559Transaction) {
        self.transaction = tx
    }
    
    func estimateGas() {
        
    }
            
    func sign() {
        
    }
    
    func send() async throws {
        
    }
    
}

/*
 
 1
 require("dotenv").config();
 2
 const AlchemyWeb3 = require("@alch/alchemy-web3");
 3
 ​
 4
 const { API_URL_HTTP_PROD_RINKEBY, PRIVATE_KEY, ADDRESS } = process.env;
 5
 const toAddress = "0x31B98D14007bDEe637298086988A0bBd31184523";
 6
 const web3 = AlchemyWeb3.createAlchemyWeb3(API_URL_HTTP_PROD_RINKEBY);
 7
 ​
 8
 async function signTx(web3, fields = {}) {
 9
   const nonce = await web3.eth.getTransactionCount(ADDRESS, 'latest');
 10
 ​
 11
   const transaction = {
 12
    'nonce': nonce,
 13
    ...fields,
 14
   };
 15
 ​
 16
   return await web3.eth.accounts.signTransaction(transaction, PRIVATE_KEY);
 17
 }
 18
 ​
 19
 async function sendTx(web3, fields = {}) {
 20
   const signedTx = await signTx(web3, fields);
 21
 ​
 22
   web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(error, hash) {
 23
     if (!error) {
 24
       console.log("Transaction sent!", hash);
 25
       const interval = setInterval(function() {
 26
         console.log("Attempting to get transaction receipt...");
 27
         web3.eth.getTransactionReceipt(hash, function(err, rec) {
 28
           if (rec) {
 29
             console.log(rec);
 30
             clearInterval(interval);
 31
           }
 32
         });
 33
       }, 1000);
 34
     } else {
 35
       console.log("Something went wrong while submitting your transaction:", error);
 36
     }
 37
   });
 38
 }
 39
 ​
 40
 function sendLegacyTx(web3) {
 41
   web3.eth.estimateGas({
 42
     to: toAddress,
 43
     data: "0xc6888fa10000000000000000000000000000000000000000000000000000000000000003"
 44
   }).then((estimatedGas) => {
 45
     web3.eth.getGasPrice().then((price) => {
 46
       sendTx(web3, {
 47
         gas: estimatedGas,
 48
         gasPrice: price,
 49
         to: toAddress,
 50
         value: 100,
 51
       });
 52
     });
 53
   });
 54
 }
 55
 ​
 56
 sendLegacyTx(web3);
 
 */

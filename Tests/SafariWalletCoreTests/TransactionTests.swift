//
//  TransactionTests.swift
//  
//
//  Created by Ronald Mannak on 1/7/22.
//

import XCTest
import MEWwalletKit
import SafariWalletCore
@testable import SafariWalletCore

class TransactionTests: XCTestCase {
    
    var bundle: AddressBundle!
    let mnemonic = "all all all all all all all all all all all all"
    var wallet: Wallet<PrivateKeyEth1>!
    
    override func setUpWithError() throws {
        wallet = try Wallet<PrivateKeyEth1>(mnemonic: mnemonic)
        let addresses = try wallet.generateAddresses(count: 5)
        bundle = AddressBundle(id: UUID(), walletName: "Wallet", type: .keystorePassword, addresses: addresses)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTransaction() async throws {
//        let privateKey = try await wallet.fetchPrivateKeyFor(index: 0)
//        let address = privateKey.address()
//        
//        let transaction = try! EIP1559Transaction(
//          nonce: "0x01",
//          maxPriorityFeePerGas: "0x07",
//          maxFeePerGas: "0x07",
//          gasLimit: "0x62d4",
//          from: address,
//          to: address,
//          value: "0x16345785D8A0000",
//          data: Data(),
//          accessList: [Acc
//            
//            .init(address: address slots: [Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000000")])],
//          chainID: Data(hex: "0x7b")
//        )
//        try transaction.sign(key: pk)
//        let serialized = transaction.serialize()
//        expect(serialized).to(equal(Data(hex: "02f8a37b0107078262d49461fac28c810253ea3a42ebbb1a5cf8687765e4ee88016345785d8a000080f838f79461fac28c810253ea3a42ebbb1a5cf8687765e4eee1a0000000000000000000000000000000000000000000000000000000000000000001a0f76cef537ee6b5a2143e4ed62debc41c19e996365ceb8b7a9ec7d7db8f83c001a01fbe06e8a4e052015af13b985047925b9f97bf145c7e7adb96f051af7c2551f0")))
//        
//        let signedHash = transaction.hash(chainID: transaction.chainID, forSignature: false)
//        expect(signedHash).to(equal(Data(hex: "0xc30b28761a4344c27f7ef7f5e3572c941111d32602a3c75e924f02fd6942bc04")))
//        
//        
//        self.id = id
//        self.transaction = EIP1559Transaction(
//          nonce: nonce,
//          maxPriorityFeePerGas: maxPriorityFeePerGas,
//          maxFeePerGas: maxFeePerGas,
//          gasLimit: gasLimit,
//          from: privateKey.address(),
//          to: Address(raw: to),
//          value: value,
//          data: Data(),
//          accessList: accessList,
//          chainID: chainID
//        )
//        self.signedTransactionRLP = Data(hex: signedTransactionRLP)
//        self.signedHash = signedHash.map { Data(hex: $0) }
//        self.pk = Data(hex: pk)
    }
    
    func testLegacyTransaction() async throws {
        
    }
    
    func testEIP1559Transaction() async throws {

//        let transaction = EIP1559Transaction(
//          nonce: nonce,
//          maxPriorityFeePerGas: maxPriorityFeePerGas,
//          maxFeePerGas: maxFeePerGas,
//          gasLimit: gasLimit,
//          from: privateKey.address(),
//          to: Address(raw: to),
//          value: value,
//          data: Data(),
//          accessList: accessList,
//          chainID: chainID
//        )
//
//        self.signedTransactionRLP = Data(hex: signedTransactionRLP)
//        self.signedHash = signedHash.map { Data(hex: $0) }
//        self.pk = Data(hex: pk)
//
//        what to compare?
    }
    
    func testEIP2930Transaction() async throws {
        
    }

}

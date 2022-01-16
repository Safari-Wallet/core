//
//  PrivateKeyTests.swift
//  
//
//  Created by Ronald Mannak on 1/7/22.
//

import XCTest
import SafariWalletCore
import MEWwalletKit

class PrivateKeyTests: XCTestCase {
        
    var bundle1: AddressBundle!
    var bundle2: AddressBundle!
    let mnemonic1 = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    let mnemonic2 = "all all all all all all all all all all all all"
    var wallet1: Wallet<PrivateKeyEth1>!
    var wallet2: Wallet<PrivateKeyEth1>!
    
    override func setUpWithError() throws {
        wallet1 = try Wallet<PrivateKeyEth1>(mnemonic: mnemonic1)
        wallet2 = try Wallet<PrivateKeyEth1>(mnemonic: mnemonic2)
        let addresses1 = try wallet1.generateAddresses(count: 5)
        let addresses2 = try wallet2.generateAddresses(count: 5)
        bundle1 = AddressBundle(id: UUID(), walletName: "Wallet 1", type: .keystorePassword, addresses: addresses1)
        bundle2 = AddressBundle(id: UUID(), walletName: "Wallet 2", type: .keystorePassword, addresses: addresses2)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDerivationPath() async throws {
        
        let privateKey0 = try await wallet1.privateKeyFor(index: 0)
        XCTAssertNotNil(privateKey0.address())
        XCTAssertEqual(privateKey0.address()!.address, bundle1.addresses[0].addressString)

        let privateKey1 = try await wallet1.privateKeyFor(index: 3)
        XCTAssertNotNil(privateKey1.address())
        XCTAssertEqual(privateKey1.address()!.address, bundle1.addresses[3].addressString)
        
        let privateKey2 = try await wallet2.privateKeyFor(index: 0)
        XCTAssertNotNil(privateKey2.address())
        XCTAssertEqual(privateKey2.address()!.address, bundle2.addresses[0].addressString)
        
        let privateKey3 = try await wallet2.privateKeyFor(index: 4)
        XCTAssertNotNil(privateKey3.address())
        XCTAssertEqual(privateKey3.address()!.address, bundle2.addresses[4].addressString)
    }


}

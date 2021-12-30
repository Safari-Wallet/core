//
//  ZerionModels.swift
//  
//
//  Created by Stefano on 30.12.21.
//

import Foundation
import MEWwalletKit

public enum Zerion {

    struct Response: Decodable {
        let payload: Payload
    }

    struct Payload: Decodable {
        let transactions: [Transaction]
    }

    struct Transaction: Decodable {
        let hash: String
        let addressFrom: String?
        let addressTo: String?
        let blockNumber: Int
        let contract: String?
        let direction: String?
        let id: String
        let minedAt: Int
        let nonce: Int?
        let changes: [Change]?
        let fee: Fee?
        let type: String
        let status: String
    }

    struct Change: Decodable {
        let price: Double?
        let addressFrom: String
        let value: Double
        let direction, addressTo: String
        let asset: ChangeAsset
        let nftAsset: NftAsset?
    }

    struct ChangeAsset: Decodable {
        let assetCode, symbol: String
        let isVerified: Bool
        let id: String
        let decimals: Int
        let price: ChangeAssetPrice?
        let iconURL: String?
        let isDisplayable: Bool
        let type: String?
        let name: String
        let implementations: Implementations
    }

    struct ChangeAssetPrice: Decodable {
        let value: Double?
        let relativeChange24h: Double?
        let changedAt: Int?
    }

    struct Implementations: Decodable {
        let ethereum: Ethereum?
    }

    struct Ethereum: Decodable {
        let address: String?
        let decimals: Int
    }

    struct NftAsset: Decodable {
        let collection: NftCollection?
        let relevantUrls: [RelevantURL]
        let description: String
        let attributes: [NftAttribute]
        let asset: NftAssetAsset
    }

    struct NftAttribute: Decodable {
        let key: String
        let value: String
    }

    struct NftAssetAsset: Decodable {
        let detail, preview: Detail
        let isVerified: Bool
        let floorPrice: Double
        let symbol: String
        let lastPrice: Double?
        let tokenId: String
        let contractAddress: String
        let type: String
        let interface: String
        let assetCode: String
        let isDisplayable: Bool
        let name: String
        let collection: NftCollection
    }

    struct NftCollection: Decodable {
        let name: String
        let iconUrl: String
        let description: String
    }

    struct Detail: Decodable {
        let url: String
    }

    struct RelevantURL: Decodable {
        let name: String
        let url: String
    }

    struct Fee: Decodable {
        let value: Int?
        let price: Double?
    }
}

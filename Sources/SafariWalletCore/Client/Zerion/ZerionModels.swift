//
//  ZerionModels.swift
//  
//
//  Created by Stefano on 30.12.21.
//

import Foundation

public enum Zerion {

    public struct Response: Decodable {
        public let payload: Payload
    }

    public struct Payload: Decodable {
        public let transactions: [Transaction]
    }

    public struct Transaction: Decodable {
        public let hash: String
        public let addressFrom: String?
        public let addressTo: String?
        public let blockNumber: Int
        public let contract: String?
        public let direction: String?
        public let id: String
        public let minedAt: Int
        public let nonce: Int?
        public let changes: [Change]?
        public let fee: Fee?
        public let type: String
        public let status: String
    }

    public struct Change: Decodable {
        public let price: Double?
        public let addressFrom: String
        public let value: Double
        public let direction, addressTo: String
        public let asset: ChangeAsset
        public let nftAsset: NftAsset?
    }

    public struct ChangeAsset: Decodable {
        public let assetCode, symbol: String
        public let isVerified: Bool
        public let id: String
        public let decimals: Int
        public let price: ChangeAssetPrice?
        public let iconURL: String?
        public let isDisplayable: Bool
        public let type: String?
        public let name: String
        public let implementations: Implementations
    }

    public struct ChangeAssetPrice: Decodable {
        public let value: Double?
        public let relativeChange24h: Double?
        public let changedAt: Int?
    }

    public struct Implementations: Decodable {
        public let ethereum: Ethereum?
    }

    public struct Ethereum: Decodable {
        public let address: String?
        public let decimals: Int
    }

    public struct NftAsset: Decodable {
        public let collection: NftCollection?
        public let relevantUrls: [RelevantURL]
        public let description: String
        public let attributes: [NftAttribute]
        public let asset: NftAssetAsset
    }

    public struct NftAttribute: Decodable {
        public let key: String
        public let value: String
    }

    public struct NftAssetAsset: Decodable {
        public let detail, preview: Detail
        public let isVerified: Bool
        public let floorPrice: Double
        public let symbol: String
        public let lastPrice: Double?
        public let tokenId: String
        public let contractAddress: String
        public let type: String
        public let interface: String
        public let assetCode: String
        public let isDisplayable: Bool
        public let name: String
        public let collection: NftCollection
    }

    public struct NftCollection: Decodable {
        public let name: String
        public let iconUrl: String
        public let description: String
    }

    public struct Detail: Decodable {
        public let url: String
    }

    public struct RelevantURL: Decodable {
        public let name: String
        public let url: String
    }

    public struct Fee: Decodable {
        public let value: Int?
        public let price: Double?
    }
}

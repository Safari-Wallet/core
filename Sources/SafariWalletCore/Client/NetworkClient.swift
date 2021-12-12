//
//  NetworkClient.swift
//  
//
//  Created by Stefano on 12.12.21.
//

import Foundation

public protocol NetworkClient {
    
    var session: URLSession { get }
    
    func fetch<T: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> T
    
    func fetch<T: Decodable>(
        from components: URLComponents,
        decoder: JSONDecoder
    ) async throws -> T
    
    func fetch<T: Decodable>(
        from url: URL,
        decoder: JSONDecoder
    ) async throws -> T
}
  
public extension NetworkClient {

    func fetch<T: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let (data, response) = try await session.data(for: request)
        return try handle(data: data, response: response, decoder: decoder)
    }
    
    func fetch<T: Decodable>(
        from components: URLComponents,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        guard let url = components.url else {
            throw NetworkError.invalidRequest
        }
        return try await fetch(from: url, decoder: decoder)
    }
    
    func fetch<T: Decodable>(
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let (data, response) = try await session.data(from: url)
        return try handle(data: data, response: response, decoder: decoder)
    }
    
    private func handle<T: Decodable>(
        data: Data,
        response: URLResponse,
        decoder: JSONDecoder
    ) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
}

final class NetworkClientImpl: NetworkClient {
    let session: URLSession = .shared
}

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case decodingFailed(String)
    case httpError(statusCode: Int)
}

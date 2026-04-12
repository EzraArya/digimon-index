//
//  NetworkService.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown("Invalid Response")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

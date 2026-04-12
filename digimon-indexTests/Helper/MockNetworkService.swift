//
//  MockNetworkService.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation
@testable import digimon_index

final class MockNetworkService: NetworkServiceProtocol {
    var result: Any?
    var error: Error?
    
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        if let error = error { throw error }
        guard let result = result as? T else {
            fatalError("MockNetworkService: Set result before calling request")
        }
        return result
    }
}

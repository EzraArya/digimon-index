//
//  NetworkError.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingFailed
    case noData
    case unknown(String)

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.serverError(let a), .serverError(let b)): return a == b
        case (.decodingFailed, .decodingFailed): return true
        case (.noData, .noData): return true
        case (.unknown(let a), .unknown(let b)): return a == b
        default: return false
        }
    }
}

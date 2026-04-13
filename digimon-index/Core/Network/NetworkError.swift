//
//  NetworkError.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case serverError(statusCode: Int)
    case notFound 
    case decodingFailed
    case noData
    case noConnection
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .notFound: return "We couldn't find any Digimon with those filters."
        case .serverError(let code): return "Server returned an error: \(code)."
        case .decodingFailed: return "There was a problem parsing the data."
        case .noData: return "The server returned no data."
        case .noConnection: return "Please check your internet connection."
        case .unknown(let msg): return msg
        }
    }
}

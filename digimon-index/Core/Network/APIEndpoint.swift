//
//  APIEndpoint.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

enum APIEndpoint {
    case digimonList(page: Int, pageSize: Int, name: String? = nil)
    case digimonDetail(id: Int)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "digi-api.com"
        
        switch self {
        case .digimonList(let page, let pageSize, let name):
            components.path = "/api/v1/digimon"
            var queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
            if let name = name {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            components.queryItems = queryItems
        case .digimonDetail(let id):
            components.path = "/api/v1/digimon/\(id)"
        }
        
        return components.url
    }
}

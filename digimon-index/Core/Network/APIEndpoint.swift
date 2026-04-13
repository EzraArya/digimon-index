//
//  APIEndpoint.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

enum APIEndpoint {
    case digimonList(page: Int, pageSize: Int, filter: DigimonSearchFilter? = nil)
    case digimonDetail(id: Int)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "digi-api.com"
        
        switch self {
        case .digimonList(let page, let pageSize, let filter):
            components.path = "/api/v1/digimon"
            var queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
            if let filter = filter {
                if let name = filter.name { queryItems.append(URLQueryItem(name: "name", value: name)) }
                if let xAntibody = filter.xAntibody { queryItems.append(URLQueryItem(name: "xAntibody", value: String(xAntibody))) }
                if let attribute = filter.attribute { queryItems.append(URLQueryItem(name: "attribute", value: attribute.rawValue)) }
                if let level = filter.level { queryItems.append(URLQueryItem(name: "level", value: level.rawValue)) }
            }
            components.queryItems = queryItems
        case .digimonDetail(let id):
            components.path = "/api/v1/digimon/\(id)"
        }
        
        return components.url
    }
}


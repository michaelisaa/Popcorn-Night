//
//  APIConfig.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 23/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation

struct APIImageConfig: Codable {
        let secureBaseUrl: String?
        let backdropSizes: [String]?
        let logoSizes: [String]?
        let posterSizes: [String]?
        let profileSizes: [String]?
        let stillSizes: [String]?
        
        enum CodingKeys: String, CodingKey {
            case secureBaseUrl = "secure_base_url"
            case backdropSizes = "backdrop_sizes"
            case logoSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
            case profileSizes = "profile_sizes"
            case stillSizes = "still_sizes"
        }
        
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            secureBaseUrl = try? container.decode(String.self, forKey: .secureBaseUrl)
            backdropSizes = try? container.decode([String].self, forKey: .backdropSizes)
            logoSizes = try? container.decode([String].self, forKey: .logoSizes)
            posterSizes = try? container.decode([String].self, forKey: .posterSizes)
            profileSizes = try? container.decode([String].self, forKey: .profileSizes)
            stillSizes = try? container.decode([String].self, forKey: .stillSizes)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(secureBaseUrl, forKey: .secureBaseUrl)
            try container.encode(backdropSizes, forKey: .backdropSizes)
            try container.encode(logoSizes, forKey: .logoSizes)
            try container.encode(posterSizes, forKey: .posterSizes)
            try container.encode(profileSizes, forKey: .profileSizes)
            try container.encode(stillSizes, forKey: .stillSizes)
        }
}

struct APIConfig: Codable {
    let changeKeys: [String]?
    let imageConfig: APIImageConfig?
    
    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case imageConfig = "images"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        changeKeys = try container.decode([String].self, forKey: .changeKeys)
        imageConfig = try container.decode(APIImageConfig.self, forKey: .imageConfig)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(changeKeys, forKey: .changeKeys)
        try container.encode(imageConfig, forKey: .imageConfig)
    }
    
}

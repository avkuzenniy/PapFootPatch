//
//  Walks.swift
//  PapFootPath
//
//  Created by 1 on 21.09.2018.
//  Copyright © 2018 Papa. All rights reserved.
//

import UIKit

class Walks: NSObject {
    
    struct Welcome: Decodable {
        let status, selectedLocale: String
        let walks: [Walk]
        let totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case status
            case selectedLocale = "selected_locale"
            case walks
            case totalCount = "total_count"
        }
    }
    
    struct Walk: Decodable {
        let walkID, walkVersion, walkTitle, walkDescription: String
        let walkLength, walkGrade, walkCounty, walkDistrict: String
        let walkType, walkRating: String
        let walkSegments: JSONNull?
        let walkStartCoordLat, walkStartCoordLong, walkIcon: String
        let walkIllustration: String?
        let walkPublished: WalkPublished
        let walkPhoto: String
        let numsegs: Int
        let walkGpxFile: String?
    }
    
    enum WalkPublished: String, Codable {
        case published = "Published"
    }
    
    // MARK: Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    var walkTitle, walkDescription, walkStartCoordLat, walkStartCoordLong, walkIllustration, walkPhoto, walkIcon, walkID, walkRating: String?
    


}

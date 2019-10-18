//
//  CodingExtensions.swift
//  App
//
//  Created by Morten Hansen on 18/10/2019.
//

import Foundation

extension KeyedDecodingContainer {

    func decode(_ type: [Photo.URLKind: URL].Type, forKey key: Key) throws -> [Photo.URLKind: URL] {
        let urlsDictionary = try self.decode([String: String].self, forKey: key)
        var result = [Photo.URLKind: URL]()
        for (key, value) in urlsDictionary {
            if let kind = Photo.URLKind(rawValue: key),
                let url = URL(string: value) {
                result[kind] = url
            }
        }
        return result
    }
    
}

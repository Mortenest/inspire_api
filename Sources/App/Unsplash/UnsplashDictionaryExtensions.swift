//
//  Dictionary+Extensions.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-16.
//  Copyright © 2017 Unsplash. All rights reserved.
//
import Foundation

extension Dictionary {
    public func convert<T, U>(_ transform: ((key: Key, value: Value)) throws -> (T, U)) rethrows -> [T: U] {
        var dictionary = [T: U]()
        for (key, value) in self {
            let transformed = try transform((key, value))
            dictionary[transformed.0] = transformed.1
        }
        return dictionary
    }
}

extension Dictionary where Key == String, Value == Any {
    func nestedValue(forKey keyToFind: String) -> Any? {
        if let value = self[keyToFind] {
            return value
        }

        for (_, value) in self {
            guard let dictionary = value as? [String: Any] else { continue }
            guard let foundValue = dictionary.nestedValue(forKey: keyToFind) else { continue }
            return foundValue
        }

        return nil
    }
}

extension KeyedDecodingContainer {

    func decode(_ type: [UnsplashPhoto.URLKind: URL].Type, forKey key: Key) throws -> [UnsplashPhoto.URLKind: URL] {
        let urlsDictionary = try self.decode([String: String].self, forKey: key)
        var result = [UnsplashPhoto.URLKind: URL]()
        for (key, value) in urlsDictionary {
            if let kind = UnsplashPhoto.URLKind(rawValue: key),
                let url = URL(string: value) {
                result[kind] = url
            }
        }
        return result
    }

    func decode(_ type: [UnsplashPhoto.LinkKind: URL].Type, forKey key: Key) throws -> [UnsplashPhoto.LinkKind: URL] {
        let linksDictionary = try self.decode([String: String].self, forKey: key)
        var result = [UnsplashPhoto.LinkKind: URL]()
        for (key, value) in linksDictionary {
            if let kind = UnsplashPhoto.LinkKind(rawValue: key),
                let url = URL(string: value) {
                result[kind] = url
            }
        }
        return result
    }

    func decode(_ type: [UnsplashUser.ProfileImageSize: URL].Type, forKey key: Key) throws -> [UnsplashUser.ProfileImageSize: URL] {
        let sizesDictionary = try self.decode([String: String].self, forKey: key)
        var result = [UnsplashUser.ProfileImageSize: URL]()
        for (key, value) in sizesDictionary {
            if let size = UnsplashUser.ProfileImageSize(rawValue: key),
                let url = URL(string: value) {
                result[size] = url
            }
        }
        return result
    }
}

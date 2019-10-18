//
//  UnsplashPhoto.swift
//  Submissions
//
//  Created by Olivier Collet on 2017-04-10.
//  Copyright © 2017 Unsplash. All rights reserved.
//
import Foundation
import Vapor

/// A struct representing a photo from the Unsplash API.
public struct UnsplashPhoto: Codable {

    public enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }

    public enum LinkKind: String, Codable {
        case own = "self"
        case html
        case download
        case downloadLocation = "download_location"
    }

    public var identifier: String
    public var height: Int
    public var width: Int
    public var color: String?
//    public let exif: UnsplashPhotoExif?
//    public let user: UnsplashUser
    public var urls: [URLKind: URL]
//    public let links: [LinkKind: URL]
    public var likesCount: Int
    public var downloadsCount: Int?
    public var viewsCount: Int?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case color
//        case exif
//        case user
//        case links
        case urls
        case likesCount = "likes"
        case downloadsCount = "downloads"
        case viewsCount = "views"
    }
    
    init(id: String, height: Int, width: Int, color: String?, urls: [URLKind: URL], likes: Int, downloads: Int?, views: Int?) {
        self.identifier = id
        self.height = height
        self.width = width
        self.color = color
        self.urls = urls
        self.likesCount = likes
        self.downloadsCount = downloads
        self.viewsCount = views
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        color = try container.decode(String.self, forKey: .color)
//        exif = try? container.decode(UnsplashPhotoExif.self, forKey: .exif)
//        user = try container.decode(UnsplashUser.self, forKey: .user)
        urls = try container.decode([URLKind: URL].self, forKey: .urls)
//        links = try container.decode([LinkKind: URL].self, forKey: .links)
        likesCount = try container.decode(Int.self, forKey: .likesCount)
        downloadsCount = try? container.decode(Int.self, forKey: .downloadsCount)
        viewsCount = try? container.decode(Int.self, forKey: .viewsCount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try? container.encode(color, forKey: .color)
//        try? container.encode(exif, forKey: .exif)
//        try container.encode(user, forKey: .user)
        try container.encode(urls.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .urls)
//        try container.encode(links.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .links)
        try container.encode(likesCount, forKey: .likesCount)
        try? container.encode(downloadsCount, forKey: .downloadsCount)
        try? container.encode(viewsCount, forKey: .viewsCount)
    }

}

extension UnsplashPhoto: Content{}

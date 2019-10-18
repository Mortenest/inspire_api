//
//  Photo.swift
//  App
//
//  Created by Morten Hansen on 18/10/2019.
//

import Vapor

public struct Photo: Codable, Content {

    public enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }

    public var id: String
    public var height: Int
    public var width: Int
    public var color: String?
    public var urls: [URLKind: URL]
    public var likes: Int = 0
    public var downloads: Int = 0
    public var views: Int = 0

    private enum CodingKeys: String, CodingKey {
        case id
        case height
        case width
        case color
        case urls
        case likes
        case downloads
        case views
    }
    
    init(id: String, height: Int, width: Int, color: String?, urls: [URLKind: URL], likes: Int, downloads: Int, views: Int) {
        self.id = id
        self.height = height
        self.width = width
        self.color = color
        self.urls = urls
        self.likes = likes
        self.downloads = downloads
        self.views = views
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        color = try? container.decode(String.self, forKey: .color)
        urls = try container.decode([URLKind: URL].self, forKey: .urls)
        likes = try container.decode(Int.self, forKey: .likes)
        downloads = try container.decode(Int.self, forKey: .downloads)
        views = try container.decode(Int.self, forKey: .views)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try? container.encode(color, forKey: .color)
        try container.encode(urls.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .urls)
        try container.encode(likes, forKey: .likes)
        try container.encode(downloads, forKey: .downloads)
        try container.encode(views, forKey: .views)
    }
}

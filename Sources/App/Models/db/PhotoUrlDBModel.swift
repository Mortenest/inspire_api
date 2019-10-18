//
//  PhotoUrlDBModel.swift
//  App
//
//  Created by Morten Hansen on 17/10/2019.
//

import FluentSQLite
import Vapor

final class PhotoUrlDBModel: Codable{
    
    var id: String?
    var photoId: String?
    var urlKind: String
    var url: String
    
    init(photoId: String?, urlKind: UnsplashPhoto.URLKind, url: URL){
        self.photoId = photoId
        self.urlKind = urlKind.rawValue
        self.url = url.absoluteString
        if let photoId = photoId {
            id = photoId + urlKind.rawValue
        }
    }
}

extension PhotoUrlDBModel: Model {
    static var idKey: WritableKeyPath<PhotoUrlDBModel, String?> {
        return \Self.id
    }
    
    typealias ID = String
    typealias Database = SQLiteDatabase
    static var entity: String = "photo_urls"
}

extension PhotoUrlDBModel: Migration {}
extension PhotoUrlDBModel: Content {}

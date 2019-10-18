//
//  PhotoDBModel.swift
//  App
//
//  Created by Morten Hansen on 17/10/2019.
//

import FluentSQLite
import Vapor

final class PhotoDBModel: Codable {
    
    public var id: String?
    public var height: Int = 0
    public var width: Int = 0
    public var color: String = ""
    public var likes: Int = 0
    public var downloads: Int = 0
    public var views: Int = 0
    
    init(photo: UnsplashPhoto){
        self.id = photo.identifier
        self.height = photo.height
        self.width = photo.width
        self.color = photo.color ?? ""
        self.likes = photo.likesCount
        self.downloads = photo.downloadsCount ?? 0
        self.views = photo.viewsCount ?? 0
    }
}

extension PhotoDBModel{
    public var urls: Children<PhotoDBModel,PhotoUrlDBModel>{
        return children(\.photoId)
    }
}

extension PhotoDBModel: Model {
    typealias Database = SQLiteDatabase
    typealias ID = String
    
    static var entity: String = "photos"
    static var idKey: WritableKeyPath<PhotoDBModel, String?> {
        return \PhotoDBModel.id
    }
}

extension PhotoDBModel: Migration {}
extension PhotoDBModel: Content {}

extension PhotoDBModel{
    func photo(on connection: DatabaseConnectable) throws -> Future<Photo>{
        guard let id = id else {throw NSError(domain: "inspire", code: 0, userInfo: nil)}
        return try urls.query(on: connection).all().map({ (dbUrls) -> (Photo) in
            
            var urls = [Photo.URLKind : URL]()
            for dbUrl in dbUrls{
                if let urlKind = Photo.URLKind(rawValue: dbUrl.urlKind), let url = URL(string: dbUrl.url){
                    urls[urlKind] = url
                } else {
                    print("Bad format: Photo URLs")
                }
            }
            let photo = Photo(id: id,
                              height: self.height,
                              width: self.width,
                              color: self.color,
                              urls: urls,
                              likes: self.likes,
                              downloads: self.downloads,
                              views: self.views)
            return photo
        })
    }
}

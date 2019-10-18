//
//  ImageFetcherServices.swift
//  App
//
//  Created by Morten Hansen on 17/10/2019.
//

import Vapor
import FluentSQLite

class ImagesFetcher: Service{
    
    let accessKey = "fde2a0011ae10e82d6747bd2044a6701586c0cac260910b70edcd798f2c291d3"
    
    let client: Client
    let app: Application
    
    init(app: Application) throws{
        self.app = app
        self.client = try app.make(Client.self)
    }
    
    @discardableResult
    func fetchImages() throws -> EventLoopFuture<[PhotoDBModel]>{
        let baseURL = URL(string: "https://api.unsplash.com/")!
        let url = baseURL.appendingPathComponent("photos")
        let headers = HTTPHeaders([("Authorization", "Client-ID \(accessKey)")])
        do {
            let res = try client.get(url, headers: headers) { _ in }.wait()
            let photos = try res.content.decode([UnsplashPhoto].self).wait()
            print(photos)
            let result = app.withNewConnection(to: .sqlite) { (connection) -> EventLoopFuture<[PhotoDBModel]> in
                
                let result = photos.map { (photo) -> EventLoopFuture<PhotoDBModel> in
                    let dbPhoto = PhotoDBModel(photo: photo).upsert(on: connection)
                   
                    var urlFutures = [EventLoopFuture<PhotoUrlDBModel>]()
                    for urlDict in photo.urls{
                        let dbPhotoUrls = PhotoUrlDBModel(photoId: photo.identifier, urlKind: urlDict.key, url: urlDict.value).upsert(on: connection)
                        urlFutures.append(dbPhotoUrls)
                    }
                    let flattenFutures = urlFutures.flatten(on: connection)
                    let collectedFutures = dbPhoto.and(flattenFutures)
                    let mapped = collectedFutures.map { (photo, _) -> (PhotoDBModel) in
                        return photo
                    }
                    return mapped
                }
                return result.flatten(on: connection)
            }
            return result
        } catch{
            throw(error)
        }
    }
}

//
//  ImageController.swift
//  App
//
//  Created by Morten Hansen on 18/10/2019.
//

import Vapor

final class ImageController{

    func images(_ req: Request) throws -> Future<[Photo]> {
        return PhotoDBModel.query(on: req).all().flatMap({ (models) in
            let result = try models.map({ try $0.photo(on: req) })
            return result.flatten(on: req)
        })
//            .join(\UnsplashPhotoUrlDBModel.photoId, to: \UnsplashPhotoDBModel.id)
//            .alsoDecode(UnsplashPhotoUrlDBModel.self).all()
//            UnsplashPhotoDBModel.query(on: req).join(\UnsplashPhotoUrlDBModel.photoId, to: \UnsplashPhotoDBModel.id).all()
    }
    
}

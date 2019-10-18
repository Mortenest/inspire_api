//
//  ModelExtensions.swift
//  App
//
//  Created by Morten Hansen on 18/10/2019.
//

import Fluent

extension Fluent.Model {
    public func upsert(on conn: DatabaseConnectable) -> Future<Self> {
        if type(of: self) == PhotoUrlDBModel.self{
                          
                  }
        guard let id = self[keyPath: \.fluentID] else { return self.create(on: conn)}
        let existingModel = Self.find(id, on: conn)
        return existingModel.flatMap({ (model) -> EventLoopFuture<Self> in

            if model != nil {
                return self.update(on: conn)
            } else{
                return self.create(on: conn)
            }
        })
    }
}


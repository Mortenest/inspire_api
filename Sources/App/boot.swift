import Vapor
import Jobs
import FluentSQLite

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    
    Jobs.add(interval: 300.seconds) {
        do {    
        let imagesFetcher = try ImagesFetcher(app: app)
        try imagesFetcher.fetchImages()
            
        } catch{
            print(error)
        }
    }
}

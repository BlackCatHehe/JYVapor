import Vapor
import Fluent
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example

    router.get { req in
        return "It works!"
    }
    
    try router.register(collection: UserController())
    
}


enum JYResultCase<T: Content> {
    case success(_ data: JYResult<T>)
    case fail(_ status: Int, errorDesc: String)
}

extension JYResultCase {
    var result: JYResult<T> {
        switch self {
        case let .success(data):
            return data
        case let .fail(s, e):
            return JYResult(status: s, data: nil, message: e)
        }
    }
}

struct JYResult<T: Content>: Content {
    var status: Int
    var data: T?
    var message: String
}

struct JYErrorResult: Content {
    var status: Int
    var message: String
}

struct JYListResult<T: Content>: Content {
    var status: Int
    var data: [T]
    var message: String
}


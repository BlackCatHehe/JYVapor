//
//  UserController.swift
//  App
//
//  Created by APP on 2019/11/13.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let routerGroup = router.grouped("api")
        
        routerGroup.get("users", use: getAllUsers)
        routerGroup.post("createUser", use: createUser)
        routerGroup.post("updateUser", use: updateUser)
    }
    
    ///获取所有用户
    func getAllUsers(_ req: Request) throws -> Future<JYListResult<User>> {
        return User.query(on: req)
            .sort(\.id, ._descending)
            .all()
            .map { (users) in
                return JYListResult(status: 0, data: users, message: "请求成功")
        }
    }
    
    ///创建一个用户
    func createUser(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self)
            .flatMap({ (user)  in
    
                guard let _ = user.nickName else {

                    return try JYResultCase<User>.fail(101, errorDesc: "缺少参数nickName").result.encode(for: req)
                }
                guard let _ = user.sex else {
                    return try JYResultCase<User>.fail(101, errorDesc: "缺少参数sex").result.encode(for: req)
                }
                guard let _ = user.age else {
                    return try JYResultCase<User>.fail(101, errorDesc: "缺少参数age").result.encode(for: req)
                }
                return user.save(on: req)
                    .flatMap { (user) in
                        return try JYResult<User>(status: 0, data: user, message: "创建用户成功").encode(for: req)
                }
            })

    }
    
    ///更新一个用户
    func updateUser(_ req: Request) throws -> Future<Response> {
        guard let inId = req.query[Int.self, at: "id"] else {
            return try JYResultCase<User>.fail(101, errorDesc: "缺少参数id").result.encode(for: req)
        }
        
        return try req.content.decode(User.self)
            .flatMap { (user)  in
            return User.query(on: req)
                .filter(\.id == inId)
                .first()
                .flatMap{ (fUser) in
                    
                    guard let sUser = fUser else {
                        return try JYResultCase<User>.fail(102, errorDesc: "没有此用户").result.encode(for: req)
                    }
                    
                    sUser.nickName = user.nickName ?? sUser.nickName
                    sUser.age = user.age ?? sUser.age
                    sUser.sex = user.sex ?? sUser.sex
                    sUser.headerImg = user.headerImg ?? sUser.headerImg
                    sUser.introduceDesc = user.introduceDesc ?? sUser.introduceDesc
                    
                    return sUser.save(on: req)
                    .flatMap { (user) in
                        return try JYResult<User>(status: 0, data: user, message: "修改用户数据成功").encode(for: req)
                    }
            }

        }
    }
}


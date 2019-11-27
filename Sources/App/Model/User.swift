//
//  User.swift
//  App
//
//  Created by APP on 2019/11/13.
//

import Vapor
import FluentMySQL

final class User {
    var id: Int?
    
    var nickName: String?
    var sex: Int? //1.男 2.女
    var age: Int?
    var headerImg: String?
    var introduceDesc: String?
    
    init(nickName: String?,
         sex: Int?,
         age: Int?,
         headerImg: String?,
         introduceDesc: String?) {
        self.nickName = nickName!
        self.sex = sex
        self.age = age
        self.headerImg = headerImg ?? "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1899397357,205586921&fm=26&gp=0.jpg"
        self.introduceDesc = introduceDesc ?? "这个人太懒，什么都没有留下"
    }
}

extension User: Content {}  
extension User: Migration {}
extension User: MySQLModel {}
extension User: Parameter {}


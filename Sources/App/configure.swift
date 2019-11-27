import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())

    //Register host
//    var nioServerConfig = NIOServerConfig.default()
//    nioServerConfig.hostname = "jy.beautyswift.cc"
//    nioServerConfig.port = 8067
//    services.register(nioServerConfig)
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a Mysql database
    let mysqlConfig = MySQLDatabaseConfig(
        hostname: "127.0.0.1",
        username: "vapor",
        password: "password",
        database: "vapor",
        transport: .unverifiedTLS  //默认cleartext（即明文），mysql>8.0采用sha2加密需要设置成.unverifiedTLS
    )
    let sqlite = MySQLDatabase(config: mysqlConfig)
    
    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .mysql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
}

import Vapor
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.post("register", use: userController.register)

    let middleWare = User.basicAuthMiddleware(using: BCryptDigest())
    let authedGroup = router.grouped(middleWare)
    authedGroup.post("login", use: userController.login)
    authedGroup.get("profile", use: userController.profile)
}

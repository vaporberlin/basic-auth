import Vapor
import Crypto

final class UserController {

    func register(_ req: Request) throws -> Future<User.Public> {
        return try req.content.decode(User.self).flatMap { user in
            let hasher = try req.make(BCryptDigest.self)
            let passwordHashed = try hasher.hash(user.password)
            let newUser = User(email: user.email, password: passwordHashed)
            return newUser.save(on: req).map { storedUser in
                return User.Public(
                    id: try storedUser.requireID(),
                    email: storedUser.email
                )
            }
        }
    }

    func login(_ req: Request) throws -> User.Public {
        let user = try req.requireAuthenticated(User.self)
        return User.Public(id: try user.requireID(), email: user.email)
    }

    func profile(_ req: Request) throws -> String {
        let user = try req.requireAuthenticated(User.self)
        return "You're viewing \(user.email) profile."
    }
}

import PromiseKit

protocol AuthenticationProtocol {
    func signIn(emailAddress: String, password: String) -> Promise<Void>
    func signUp(emailAddress: String, password: String) -> Promise<Void>
}

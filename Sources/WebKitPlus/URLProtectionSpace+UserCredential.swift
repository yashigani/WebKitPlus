import Foundation

extension URLProtectionSpace {
    internal var isUserCredential: Bool {
        switch authenticationMethod {
        case NSURLAuthenticationMethodDefault where `protocol` == "http":
            return true
        case NSURLAuthenticationMethodHTTPBasic, NSURLAuthenticationMethodHTTPDigest:
            return true
        default:
            return false
        }
    }
}

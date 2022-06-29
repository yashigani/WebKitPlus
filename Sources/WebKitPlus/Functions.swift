import UIKit

/// Return UIAlertController? that input form for user credential if needed.
public func alert(for challenge: URLAuthenticationChallenge, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController? {
    let space = challenge.protectionSpace
    guard space.isUserCredential else {
        return nil
    }
    let alert = UIAlertController(title: "\(space.`protocol`!)://\(space.host):\(space.port)", message: space.realm, preferredStyle: .alert)
    alert.addTextField {
        $0.placeholder = localizedString(for: "user")
    }
    alert.addTextField {
        $0.placeholder = localizedString(for: "password")
        $0.isSecureTextEntry = true
    }
    alert.addAction(UIAlertAction(title: localizedString(for: "Cancel"), style: .cancel) { _ in
        completion(.cancelAuthenticationChallenge, nil)
    })
    alert.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in
        let textFields = alert.textFields!
        let credential = URLCredential(user: textFields[0].text!, password: textFields[1].text!, persistence: .forSession)
        completion(.useCredential, credential)
    })
    return alert
}

@available(*, unavailable, renamed: "alert(for:completion:)")
public func alertForAuthentication(_ challenge: URLAuthenticationChallenge, _ completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController? {
    fatalError()
}

extension URLProtectionSpace {

    fileprivate var isUserCredential: Bool {
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

public func alert(for error: NSError) -> UIAlertController? {
    if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled { return nil }
    // Ignore WebKitErrorFrameLoadInterruptedByPolicyChange
    if error.domain == "WebKitErrorDomain" && error.code == 102 { return nil }

    let title = error.userInfo[NSURLErrorFailingURLStringErrorKey] as? String
    let message = error.localizedDescription
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in })
    return alert
}

@available(*, unavailable, renamed: "alert(for:)")
public func alertForNavigationFailed(_ error: NSError) -> UIAlertController? { fatalError() }

func localizedString(for key: String) -> String {
    let bundle = Bundle(for: WKUIDelegatePlus.self)
    return bundle.localizedString(forKey: key, value: key, table: nil)
}


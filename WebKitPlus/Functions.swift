import UIKit

/// Return UIAlertController? that input form for user credential if needed.
public func alertForAuthentication(_ challenge: URLAuthenticationChallenge, _ completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController? {
    let space = challenge.protectionSpace
    let alert: UIAlertController?
    if space.isUserCredential {
        alert = UIAlertController(title: "\(space.`protocol`!)://\(space.host):\(space.port)", message: space.realm, preferredStyle: .alert)
        alert?.addTextField {
            $0.placeholder = localizedString("user")
        }
        alert?.addTextField {
            $0.placeholder = localizedString("password")
            $0.isSecureTextEntry = true
        }
        alert?.addAction(UIAlertAction(title: localizedString("Cancel"), style: .cancel) { _ in
            completionHandler(.cancelAuthenticationChallenge, nil)
        })
        alert?.addAction(UIAlertAction(title: localizedString("OK"), style: .default) { _ in
            let textFields = alert!.textFields!
            let credential = URLCredential(user: textFields[0].text!, password: textFields[1].text!, persistence: .forSession)
            completionHandler(.useCredential, credential)
        })
    } else {
        alert = nil
    }
    return alert
}

extension URLProtectionSpace {

    fileprivate var isUserCredential: Bool {
        if let p = `protocol` , p == "http" && authenticationMethod == NSURLAuthenticationMethodDefault {
            return true
        } else if authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
            return true
        } else {
            return false
        }
    }

}

public func alertForNavigationFailed(_ error: NSError) -> UIAlertController? {
    if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled { return nil }
    // Ignore WebKitErrorFrameLoadInterruptedByPolicyChange
    if error.domain == "WebKitErrorDomain" && error.code == 102 { return nil }

    let title = error.userInfo[NSURLErrorFailingURLStringErrorKey] as? String
    let message = error.localizedDescription
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: localizedString("OK"), style: .default) { _ in })
    return alert
}

func localizedString(_ key: String) -> String {
    let bundle = Bundle(for: WKUIDelegatePlus.self)
    return bundle.localizedString(forKey: key, value: key, table: nil)
}


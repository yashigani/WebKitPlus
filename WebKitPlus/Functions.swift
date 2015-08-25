import UIKit

/// Return UIAlertController? that input form for user credential if needed.
public func alertForAuthentication(challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) -> UIAlertController? {
    let space = challenge.protectionSpace
    let alert: UIAlertController?
    if space.isUserCredential {
        alert = UIAlertController(title: "\(space.`protocol`!)://\(space.host):\(space.port)", message: space.realm, preferredStyle: .Alert)
        alert?.addTextFieldWithConfigurationHandler {
            $0.placeholder = localizedString("user")
        }
        alert?.addTextFieldWithConfigurationHandler {
            $0.placeholder = localizedString("password")
            $0.secureTextEntry = true
        }
        alert?.addAction(UIAlertAction(title: localizedString("Cancel"), style: .Cancel) { _ in
            completionHandler(.CancelAuthenticationChallenge, nil)
        })
        alert?.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in
            let textFields = alert!.textFields as! [UITextField]
            let credential = NSURLCredential(user: textFields[0].text!, password: textFields[1].text!, persistence: .ForSession)
            completionHandler(.UseCredential, credential)
        })
    } else {
        alert = nil
    }
    return alert
}

extension NSURLProtectionSpace {

    private var isUserCredential: Bool {
        if let p = `protocol` where p == "http" && authenticationMethod == NSURLAuthenticationMethodDefault {
            return true
        } else if authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
            return true
        } else {
            return false
        }
    }

}

public func alertForNavigationFailed(error: NSError) -> UIAlertController? {
    if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled { return nil }
    // Ignore WebKitErrorFrameLoadInterruptedByPolicyChange
    if error.domain == "WebKitErrorDomain" && error.code == 102 { return nil }

    let title = error.userInfo?[NSURLErrorFailingURLStringErrorKey] as? String
    let message = error.localizedDescription
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in })
    return alert
}

func localizedString(key: String) -> String {
    let bundle = NSBundle(forClass: WKUIDelegatePlus.self)
    return bundle.localizedStringForKey(key, value: key, table: nil)
}


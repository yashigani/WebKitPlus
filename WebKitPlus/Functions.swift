import UIKit

public func alertForAuthentication(challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) -> UIAlertController {
    let space = challenge.protectionSpace
    let alert = UIAlertController(title: "\(space.`protocol`!)://\(space.host):\(space.port)", message: space.realm, preferredStyle: .Alert)
    alert.addTextFieldWithConfigurationHandler {
        $0.placeholder = localizedString("user")
    }
    alert.addTextFieldWithConfigurationHandler {
        $0.placeholder = localizedString("password")
        $0.secureTextEntry = true
    }
        alert.addAction(UIAlertAction(title: localizedString("Cancel"), style: .Cancel) { _ in
            completionHandler(.CancelAuthenticationChallenge, nil)
        })
        alert.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in
            let textFields = alert.textFields as! [UITextField]
            let credential = NSURLCredential(user: textFields[0].text, password: textFields[1].text, persistence: .ForSession)
            completionHandler(.UseCredential, credential)
        })
    return alert
}

public func alertForNavigationFailed(error: NSError) -> UIAlertController {
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


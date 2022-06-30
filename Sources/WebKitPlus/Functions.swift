import UIKit

/// Return UIAlertController? that input form for user credential if needed.
@available(*, deprecated, renamed: "UIAlertController(for:completion:)")
public func alert(for challenge: URLAuthenticationChallenge, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController? {
    return UIAlertController(for: challenge, completion: completion)
}

@available(*, unavailable, renamed: "UIAlertController(for:completion:)")
public func alertForAuthentication(_ challenge: URLAuthenticationChallenge, _ completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController? {
    fatalError()
}

@available(*, deprecated, renamed: "UIAlertController(error:)")
public func alert(for error: NSError) -> UIAlertController? {
    return UIAlertController(error: error)
}

@available(*, unavailable, renamed: "UIAlertController(error:)")
public func alertForNavigationFailed(_ error: NSError) -> UIAlertController? {
    fatalError()
}

func localizedString(for key: String) -> String {
    let bundle = Bundle(for: WKUIDelegatePlus.self)
    return bundle.localizedString(forKey: key, value: key, table: nil)
}


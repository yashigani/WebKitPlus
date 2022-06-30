import UIKit

extension UIAlertController {
    public convenience init?(for challenge: URLAuthenticationChallenge, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let space = challenge.protectionSpace
        guard space.isUserCredential else {
            return nil
        }
        self.init(title: "\(space.`protocol`!)://\(space.host):\(space.port)", message: space.realm, preferredStyle: .alert)
        self.addTextField {
            $0.placeholder = localizedString(for: "user")
        }
        self.addTextField {
            $0.placeholder = localizedString(for: "password")
            $0.isSecureTextEntry = true
        }
        self.addAction(UIAlertAction(title: localizedString(for: "Cancel"), style: .cancel) { _ in
            completion(.cancelAuthenticationChallenge, nil)
        })
        self.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { [weak self] _ in
            let textFields = self!.textFields!
            let credential = URLCredential(user: textFields[0].text!, password: textFields[1].text!, persistence: .forSession)
            completion(.useCredential, credential)
        })
    }

    public convenience init?(error: NSError) {
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
            return nil
        }
        // Ignore WebKitErrorFrameLoadInterruptedByPolicyChange
        if error.domain == "WebKitErrorDomain" && error.code == 102 {
            return nil
        }

        let title = error.userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        let message = error.localizedDescription
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in })
    }
}

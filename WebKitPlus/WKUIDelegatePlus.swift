import UIKit
import WebKit

public class WKUIDelegatePlus: NSObject {
    public var createNewWebView: (WKWebView, WKWebViewConfiguration, WKNavigationAction, WKWindowFeatures) -> WKWebView? = { _, _, _, _ in nil }
    public var runJavaScriptAlert: (UIAlertController, WKFrameInfo) -> Void = { _, _ in }

    public init(parentViewController viewController: UIViewController) {
        weak var vc = viewController
        runJavaScriptAlert = { alert, _ in
            vc?.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension WKUIDelegatePlus: WKUIDelegate {

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let webView = createNewWebView(webView, configuration, navigationAction, windowFeatures) {
            return webView
        } else {
            webView.load(navigationAction.request)
            return nil
        }
    }

    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        guard webView.window != nil else {
            completionHandler()
            return
        }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in
            completionHandler()
        })
        runJavaScriptAlert(alert, frame)
    }

    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        guard webView.window != nil else {
            completionHandler(false)
            return
        }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localizedString(for: "Cancel"), style: .cancel) { _ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in
            completionHandler(true)
        })
        runJavaScriptAlert(alert, frame)
    }

    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        guard webView.window != nil else {
            completionHandler(nil)
            return
        }

        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { $0.text = defaultText }
        alert.addAction(UIAlertAction(title: localizedString(for: "Cancel"), style: .cancel) { _ in
            completionHandler(nil)
        })
        alert.addAction(UIAlertAction(title: localizedString(for: "OK"), style: .default) { _ in
            let textField = alert.textFields!.first!
            completionHandler(textField.text)
        })
        runJavaScriptAlert(alert, frame)
    }

}

public extension WKUIDelegatePlus {
    @available(*, unavailable, renamed: "init(parentViewController:)")
    public convenience init(_ viewController: UIViewController) { fatalError() }
}


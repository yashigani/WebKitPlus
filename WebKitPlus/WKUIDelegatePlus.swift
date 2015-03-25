import UIKit
import WebKit

public class WKUIDelegatePlus: NSObject {
    public typealias WebViewCreator = (WKWebView, WKWebViewConfiguration, WKNavigationAction, WKWindowFeatures) -> WKWebView?
    public typealias AlertCreator = (UIAlertController, WKFrameInfo) -> Void

    public var createNewWebView: WebViewCreator = { _, _, _, _ in nil }
    public var runJavaScriptAlert: AlertCreator = { _, _ in }

    public init(_ viewController: UIViewController) {
        weak var vc = viewController
        runJavaScriptAlert = { alert, _ in
            vc?.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
}

extension WKUIDelegatePlus: WKUIDelegate {

    public func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let webView = createNewWebView(webView, configuration, navigationAction, windowFeatures) {
            return webView
        } else {
            webView.loadRequest(navigationAction.request)
            return nil
        }
    }

    public func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in
            completionHandler()
        })
        runJavaScriptAlert(alert, frame)
    }

    public func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: localizedString("Cancel"), style: .Cancel) { _ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in
            completionHandler(true)
        })
        runJavaScriptAlert(alert, frame)
    }

    public func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String!) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { $0.text = defaultText }
        alert.addAction(UIAlertAction(title: localizedString("Cancel"), style: .Cancel) { _ in
            completionHandler(nil)
        })
        alert.addAction(UIAlertAction(title: localizedString("OK"), style: .Default) { _ in
            let textField = (alert.textFields as [UITextField]).first!
            completionHandler(textField.text)
        })
        runJavaScriptAlert(alert, frame)
    }

}


import UIKit
import WebKit

public class WebViewObserver: NSObject {
    let webView: WKWebView
    private let context = UnsafeMutablePointer<Void>()
    private let observableProperties = ["title", "URL", "estimatedProgress", "hasOnlySecureContent", "loading"]

    public var onTitleChanged: String? -> Void = { _ in }
    public var onURLChanged: NSURL? -> Void = { _ in }
    public var onProgressChanged: Double -> Void = { _ in }
    public var onHasOnlySecureContentChanged: Bool -> Void = { _ in }
    public var onLoadingStatusChanged: Bool -> Void = { _ in }

    // MARK: -

    public init(_ webView: WKWebView) {
        self.webView = webView
        super.init()
        observeProperties()
    }

    private func observeProperties() {
        for key in observableProperties {
            webView.addObserver(self, forKeyPath: key, options: .New, context: context)
        }
    }

    deinit {
        for key in observableProperties {
            webView.removeObserver(self, forKeyPath: key, context: context)
        }
    }

    // MARK: - Key Value Observation

    public override func observeValueForKeyPath(keyPath: String, ofObject: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context != self.context { return }

        switch keyPath {
        case "title": onTitleChanged(webView.title)
        case "URL": onURLChanged(webView.URL)
        case "estimatedProgress": onProgressChanged(webView.estimatedProgress)
        case "hasOnlySecureContent": onHasOnlySecureContentChanged(webView.hasOnlySecureContent)
        case "loading": onLoadingStatusChanged(webView.loading)
        default: ()
        }
    }

}


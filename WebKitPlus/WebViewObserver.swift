import UIKit
import WebKit

open class WebViewObserver: NSObject {
    enum KeyPath: String {
        case title
        case url
        case estimatedProgress
        case canGoBack
        case canGoForward
        case hasOnlySecureContent
        case loading
    }
    let webView: WKWebView
    fileprivate var context: UInt8 = 0
    fileprivate let keyPaths: [KeyPath] = [
        .title, .url, .estimatedProgress,
        .canGoBack, .canGoForward,
        .hasOnlySecureContent, .loading,
    ]

    open var onTitleChanged: (String?) -> Void = { _ in }
    open var onURLChanged: (URL?) -> Void = { _ in }
    open var onProgressChanged: (Double) -> Void = { _ in }
    open var onCanGoBackChanged: (Bool) -> Void = { _ in }
    open var onCanGoForwardChanged: (Bool) -> Void = { _ in }
    open var onHasOnlySecureContentChanged: (Bool) -> Void = { _ in }
    open var onLoadingStatusChanged: (Bool) -> Void = { _ in }

    // MARK: -

    public init(_ webView: WKWebView) {
        self.webView = webView
        super.init()
        observeProperties()
    }

    fileprivate func observeProperties() {
        for k in keyPaths {
            webView.addObserver(self, forKeyPath: k.rawValue, options: .new, context: &context)
        }
    }

    deinit {
        for k in keyPaths {
            webView.removeObserver(self, forKeyPath: k.rawValue, context: &context)
        }
    }

    fileprivate func dispatchObserver(_ keyPath: KeyPath) {
        switch keyPath {
        case .title: onTitleChanged(webView.title)
        case .url: onURLChanged(webView.url)
        case .estimatedProgress: onProgressChanged(webView.estimatedProgress)
        case .canGoBack: onCanGoBackChanged(webView.canGoBack)
        case .canGoForward: onCanGoForwardChanged(webView.canGoForward)
        case .hasOnlySecureContent: onHasOnlySecureContentChanged(webView.hasOnlySecureContent)
        case .loading: onLoadingStatusChanged(webView.isLoading)
        }
    }

    // MARK: - Key Value Observation

    open override func observeValue(forKeyPath keyPath: String?, of ofObject: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &self.context else {
            return
        }
        if let keyPath = keyPath.flatMap(KeyPath.init) {
            dispatchObserver(keyPath)
        }
    }

}


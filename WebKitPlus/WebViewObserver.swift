import UIKit
import WebKit

public class WebViewObserver: NSObject {
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
    private var context: UInt8 = 0
    private let keyPaths: [KeyPath] = [
        .title, .url, .estimatedProgress,
        .canGoBack, .canGoForward,
        .hasOnlySecureContent, .loading,
    ]

    public var onTitleChanged: (String?) -> Void = { _ in }
    public var onURLChanged: (URL?) -> Void = { _ in }
    public var onProgressChanged: (Double) -> Void = { _ in }
    public var onCanGoBackChanged: (Bool) -> Void = { _ in }
    public var onCanGoForwardChanged: (Bool) -> Void = { _ in }
    public var onHasOnlySecureContentChanged: (Bool) -> Void = { _ in }
    public var onLoadingStatusChanged: (Bool) -> Void = { _ in }

    // MARK: -

    public init(obserbee webView: WKWebView) {
        self.webView = webView
        super.init()
        observeProperties()
    }

    private func observeProperties() {
        for k in keyPaths {
            webView.addObserver(self, forKeyPath: k.rawValue, options: .new, context: &context)
        }
    }

    deinit {
        for k in keyPaths {
            webView.removeObserver(self, forKeyPath: k.rawValue, context: &context)
        }
    }

    private func dispatchObserver(_ keyPath: KeyPath) {
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

    public override func observeValue(forKeyPath keyPath: String?, of ofObject: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &self.context else {
            return
        }
        if let keyPath = keyPath.flatMap(KeyPath.init) {
            dispatchObserver(keyPath)
        }
    }

}

public extension WebViewObserver {
    @available(*, unavailable, renamed: "init(obserbee:)")
    public convenience init(_ webView: WKWebView) { fatalError() }

}


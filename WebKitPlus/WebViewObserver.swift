import UIKit
import WebKit

public class WebViewObserver: NSObject {
    enum KeyPath: String {
        case Title = "title"
        case URL = "URL"
        case EstimatedProgress = "estimatedProgress"
        case CanGoBack = "canGoBack"
        case CanGoForward = "canGoForward"
        case HasOnlySecureContent = "hasOnlySecureContent"
        case Loading = "loading"
    }
    let webView: WKWebView
    private var context: UInt8 = 0
    private let keyPaths: [KeyPath] = [
        .Title, .URL, .EstimatedProgress,
        .CanGoBack, .CanGoForward,
        .HasOnlySecureContent, .Loading,
    ]

    public var onTitleChanged: String? -> Void = { _ in }
    public var onURLChanged: NSURL? -> Void = { _ in }
    public var onProgressChanged: Double -> Void = { _ in }
    public var onCanGoBackChanged: Bool -> Void = { _ in }
    public var onCanGoForwardChanged: Bool -> Void = { _ in }
    public var onHasOnlySecureContentChanged: Bool -> Void = { _ in }
    public var onLoadingStatusChanged: Bool -> Void = { _ in }

    // MARK: -

    public init(_ webView: WKWebView) {
        self.webView = webView
        super.init()
        observeProperties()
    }

    private func observeProperties() {
        for k in keyPaths {
            webView.addObserver(self, forKeyPath: k.rawValue, options: .New, context: &context)
        }
    }

    deinit {
        for k in keyPaths {
            webView.removeObserver(self, forKeyPath: k.rawValue, context: &context)
        }
    }

    private func dispatchObserver(keyPath: KeyPath) {
        switch keyPath {
        case .Title: onTitleChanged(webView.title)
        case .URL: onURLChanged(webView.URL)
        case .EstimatedProgress: onProgressChanged(webView.estimatedProgress)
        case .CanGoBack: onCanGoBackChanged(webView.canGoBack)
        case .CanGoForward: onCanGoForwardChanged(webView.canGoForward)
        case .HasOnlySecureContent: onHasOnlySecureContentChanged(webView.hasOnlySecureContent)
        case .Loading: onLoadingStatusChanged(webView.loading)
        }
    }

    // MARK: - Key Value Observation

    public override func observeValueForKeyPath(keyPath: String?, ofObject: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &self.context else {
            return
        }
        if let keyPath = keyPath.flatMap(KeyPath.init) {
            dispatchObserver(keyPath)
        }
    }

}


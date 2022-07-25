import UIKit
import WebKit

public class WebViewObserver: NSObject {
    let webView: WKWebView
    private var observations: [NSKeyValueObservation] = []

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

        self.observations.append(
            webView.observe(\.title, options: .new) { [weak self] _, change in
                guard let title = change.newValue else {
                    return
                }
                self?.onTitleChanged(title)
            }
        )
        self.observations.append(
            webView.observe(\.url, options: .new) { [weak self] _, change in
                guard let url = change.newValue else {
                    return
                }
                self?.onURLChanged(url)
            }
        )
        self.observations.append(
            webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
                guard let progress = change.newValue else {
                    return
                }
                self?.onProgressChanged(progress)
            }
        )
        self.observations.append(
            webView.observe(\.canGoBack, options: .new) { [weak self] _, change in
                guard let canGoBackChanged = change.newValue else {
                    return
                }
                self?.onCanGoBackChanged(canGoBackChanged)
            }
        )
        self.observations.append(
            webView.observe(\.canGoForward, options: .new) { [weak self] _, change in
                guard let canGoForward = change.newValue else {
                    return
                }
                self?.onCanGoForwardChanged(canGoForward)
            }
        )
        self.observations.append(
            webView.observe(\.hasOnlySecureContent, options: .new) { [weak self] _, change in
                guard let hasOnlySecureContent = change.newValue else {
                    return
                }
                self?.onHasOnlySecureContentChanged(hasOnlySecureContent)
            }
        )
        self.observations.append(
            webView.observe(\.isLoading, options: .new) { [weak self] _, change in
                guard let isLoading = change.newValue else {
                    return
                }
                self?.onLoadingStatusChanged(isLoading)
            }
        )
    }

}

public extension WebViewObserver {
    @available(*, unavailable, renamed: "init(obserbee:)")
    convenience init(_ webView: WKWebView) { fatalError() }

}


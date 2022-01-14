import UIKit
import WebKit

/// Simple UIViewController with WKWebView
open class ZenWebViewController: UIViewController {
    public lazy var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    public lazy var webView: WKWebView = WKWebView(frame: self.view.frame, configuration: self.configuration)
    public lazy var UIDelegate: WKUIDelegatePlus = WKUIDelegatePlus(parentViewController: self)
    public lazy var observer: WebViewObserver = WebViewObserver(obserbee: self.webView)

    override open func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = UIDelegate
        view.insertSubview(webView, at: 0)

        webView.scrollView.contentInsetAdjustmentBehavior = .scrollableAxes

        let constraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - IBAction

    @IBAction func goBack(_: AnyObject?) {
        webView.goBack()
    }

    @IBAction func goForward(_: AnyObject?) {
        webView.goForward()
    }

    @IBAction func reload(_: AnyObject?) {
        webView.reload()
    }

    @IBAction func reloadFromOrigin(_: AnyObject?) {
        webView.reloadFromOrigin()
    }

    @IBAction func stopLoading(_: AnyObject?) {
        webView.stopLoading()
    }

}


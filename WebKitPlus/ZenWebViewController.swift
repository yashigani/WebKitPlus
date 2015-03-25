import UIKit
import WebKit

/// Simple UIViewController with WKWebView
public class ZenWebViewController: UIViewController {
    public lazy var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    public lazy var webView: WKWebView = WKWebView(frame: self.view.frame, configuration: self.configuration)
    public lazy var UIDelegate: WKUIDelegatePlus = WKUIDelegatePlus(self)
    public lazy var observer: WebViewObserver = WebViewObserver(self.webView)

    init(_ configuration: WKWebViewConfiguration) {
        super.init()
        self.configuration = configuration
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func loadView() {
        super.loadView()
        let autoresizingMask: UIViewAutoresizing = .FlexibleWidth | .FlexibleHeight
        webView.autoresizingMask = autoresizingMask
        webView.UIDelegate = UIDelegate
        view.insertSubview(webView, atIndex: 0)
    }

    // MARK: - IBAction

    @IBAction func goBack(_: AnyObject?) {
        if webView.canGoBack { webView.goBack() }
    }

    @IBAction func goForward(_: AnyObject?) {
        if webView.canGoForward { webView.goForward() }
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


import UIKit
import WebKit

/// Simple UIViewController with WKWebView
public class ZenWebViewController: UIViewController {
    public lazy var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    public lazy var webView: WKWebView = WKWebView(frame: self.view.frame, configuration: self.configuration)
    public lazy var UIDelegate: WKUIDelegatePlus = WKUIDelegatePlus(self)
    public lazy var observer: WebViewObserver = WebViewObserver(self.webView)

    override public func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.UIDelegate = UIDelegate
        view.insertSubview(webView, atIndex: 0)

        let views = ["view": webView]
        NSLayoutConstraint.activateConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: [], metrics: nil, views: views) +
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: [], metrics: nil, views: views)
        )
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


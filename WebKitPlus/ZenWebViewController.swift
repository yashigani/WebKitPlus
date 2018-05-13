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

        if #available(iOSApplicationExtension 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            let views = ["view": webView]
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: views) +
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: views)
            )
        }
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


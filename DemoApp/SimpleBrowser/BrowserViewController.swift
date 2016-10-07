import UIKit
import WebKit
import WebKitPlus

class BrowserViewController: ZenWebViewController {
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var goBackItem: UIBarButtonItem!
    @IBOutlet var goForwardItem: UIBarButtonItem!
    @IBOutlet var reloadItem: UIBarButtonItem!
    @IBOutlet var stopItem: UIBarButtonItem!
    @IBOutlet var shareItem: UIBarButtonItem!
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems?.removeLast()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self

        // observe WebView status
        observer.onTitleChanged = updateTitle
        observer.onProgressChanged = updateProgress
        observer.onLoadingStatusChanged = updateStatus

        // hide navigation bar
        navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(BrowserViewController.updateStatusBar(_:)))

        let request = URLRequest(url: URL(string: "https://www.apple.com")!)
        webView.load(request)
    }

    // MARK: - Update UI

    func updateTitle(_ newTitle: String?) {
        title = newTitle
    }

    func updateProgress(_ progress: Double) {
        progressBar.progress = Float(progress)
    }

    func updateStatus(_ loading: Bool) {
        progressBar.isHidden = !loading
        toolbarItems?.remove(at: 5)
        toolbarItems?.insert(loading ? stopItem : reloadItem, at: 5)
        goBackItem.isEnabled = webView.canGoBack
        goForwardItem.isEnabled = webView.canGoForward
        shareItem.isEnabled = !loading
    }

    func updateStatusBar(_: AnyObject?) {
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Actions

    @IBAction func shareTapped(_: AnyObject?) {
        let vc = UIActivityViewController(activityItems: [webView.url!, webView.title!], applicationActivities: nil)
        navigationController?.present(vc, animated: true, completion: nil)
    }

}

extension BrowserViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let alert = alert(for: challenge, completion: completionHandler) else {
            // Should call `completionHandler` if `alertForAuthentication` return `.None`.
            completionHandler(.performDefaultHandling, nil)
            return
        }
        present(alert, animated: true, completion: nil)
    }

}


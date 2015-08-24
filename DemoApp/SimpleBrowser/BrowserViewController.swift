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
        navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: "updateStatusBar:")

        let request = NSURLRequest(URL: NSURL(string: "https://www.apple.com")!)
        webView.loadRequest(request)
    }

    override func prefersStatusBarHidden() -> Bool { return navigationController?.navigationBarHidden ?? false }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation { return .Slide }

    // MARK: - Update UI

    func updateTitle(newTitle: String?) {
        title = newTitle
    }

    func updateProgress(progress: Double) {
        progressBar.progress = Float(progress)
    }

    func updateStatus(loading: Bool) {
        progressBar.hidden = !loading
        toolbarItems?.removeAtIndex(5)
        toolbarItems?.insert(loading ? stopItem : reloadItem, atIndex: 5)
        goBackItem.enabled = webView.canGoBack
        goForwardItem.enabled = webView.canGoForward
        shareItem.enabled = !loading
    }

    func updateStatusBar(_: AnyObject?) {
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Actions

    @IBAction func shareTapped(_: AnyObject?) {
        let vc = UIActivityViewController(activityItems: [webView.URL!, webView.title!], applicationActivities: nil)
        navigationController?.presentViewController(vc, animated: true, completion: nil)
    }

}

extension BrowserViewController: WKNavigationDelegate {

    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if let alert = alertForAuthentication(challenge, completionHandler) {
            presentViewController(alert, animated: true, completion: nil)
        } else {
            completionHandler(.RejectProtectionSpace, nil)
        }
    }

}


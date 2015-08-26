WebKitPlus
==========

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A support library for WKWebView.

## Requirements

- iOS 8.0 later

## Usage

### WKUIDelegatePlus
`WKUIDelegatePlus` has standard implements(Present alerts from JavaScript) for `WKUIDelegate`.

``` swift
override public func viewDidLoad() {
    super.viewDidLoad()
    UIDelegate = WKUIDelegatePlus(self)
    webView.UIDelegate = UIDelegate
}
```

### WebViewObserver
It is funtastic that `WKWebView` has key-value observing compliant properties, but KVO is so ugly. `WebViewObserver` makes observable it by closure.

``` swift
lazy var observer: WebViewObserver = WebViewObserver(self.webView)
override public func viewDidLoad() {
    super.viewDidLoad()
    observer.onTitleChanged = { [weak self] in self?.title = $0 }
    observer.onProgressChanged = { [weak self] in self?.progressbar.progress = $0 }
}
```

### Authentication in navigation
`alertForAuthentication` function create `UIAlertController` for input informations of authenticcation.

``` swift
/// in `WKWebNavigationDelegate` object
func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    guard let alert = alertForAuthentication(challenge, completionHandler) else {
        // Should call `completionHandler` if `alertForAuthentication` return `.None`.
        completionHandler(.PerformDefaultHandling, nil)
        return
    }
    presentViewController(alert, animated: true, completion: nil)
}
```

### ZenWebViewController
`ZenWebViewController` is a Simple View Controller contains `WKWebView`. You can implement simple web browser with it.

## Author
@yashigani

## License
WebKitPlus is available under the MIT license. See the LICENSE file for more info.

Pod::Spec.new do |s|
    s.name = "WebKitPlus"
    s.version = "0.4.0"
    s.summary = "A support library for WKWebView."

    s.description = <<-DESC
    WebKitPlus is a support library for WKWebView in iOS Apps.
    DESC

    s.authors = { "yashigani" => "tai.fukui@gmail.com" }
    s.homepage = "https://github.com/yashigani/WebKitPlus"
    s.license = { :type => "MIT", :file => "LICENSE" }

    s.ios.deployment_target = "12.0"
    s.framework = "WebKit"
    s.source = { :git => "https://github.com/yashigani/WebKitPlus.git", :tag => "#{s.version}" }

    s.source_files = "Sources/WebKitPlus/**/*.{swift,h}"
    s.resource_bundles = { "WebKitPlus" => ["Sources/WebKitPlus/Resources/**/*.lproj"] }
    s.pod_target_xcconfig = { "APPLICATION_EXTENSION_API_ONLY" => "YES" }

    s.swift_version = "5.0"
    s.cocoapods_version = ">= 1.4.0"
end


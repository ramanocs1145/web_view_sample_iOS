import UIKit
import WebKit
import KRProgressHUD

class WebViewController: UIViewController, WKNavigationDelegate {
    private let webView: WKWebView
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        let configuration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        super.init(nibName: nil, bundle: nil)
        self.webView.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupWebView()
        loadURL()
    }
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
        
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL")
            return
        }
        webView.load(URLRequest(url: url))
        showLoader()  // Show the loader while loading the web view
    }
    
    private func showAlert(message: String) {
        AlertHelper.showAlert(on: self, message: message)
    }
    
    private func showLoader() {
        KRProgressHUD.showOn(self).show()
    }

    private func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            KRProgressHUD.dismiss()
        }
    }
    
    // WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()  // Hide the loader once the page finishes loading
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()  // Hide the loader in case of error
        showAlert(message: "Failed to load the page: \(error.localizedDescription)")
    }
}


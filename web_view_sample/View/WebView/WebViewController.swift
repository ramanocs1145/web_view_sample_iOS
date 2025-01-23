import UIKit
import WebKit
import KRProgressHUD

class WebViewController: UIViewController, WKNavigationDelegate {
    private let webView: WKWebView
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        let webViewConfiguration = WKWebViewConfiguration()
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = true // Enable JavaScript
        webViewConfiguration.defaultWebpagePreferences = webpagePreferences

        self.webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        super.init(nibName: nil, bundle: nil)
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
        webView.navigationDelegate = self
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
        
        let script = """
        var eventMethod = window.addEventListener ? "addEventListener": "attachEvent"; 
        var eventer = window[eventMethod]; 
        var messageEvent = eventMethod == "attachEvent" ? "onmessage": "message"; 

        eventer(messageEvent, function(e) { 
            console.log(JSON.parse(e.data)); // This will show all the result attributes 
            var result = JSON.parse(e.data); 
            console.log(result); // Check the entire result object for clarity

            if (result['status'] === "SUCCESS") { 
                alert("Transaction successful. Transaction ID: " + result['transaction_id']); 
            } else if (result['status'] === "CANCELLED") { 
                alert(result['remark']); 
            } else if (result['status'] === "FAILED") { 
                alert("Transaction failed. Transaction ID: " + result['transaction_id']); 
            } 
            alert("This is a test alert for CANCELLED status.");

            document.getElementById('myModal').style.display = 'none';
        }, false);
        """
        
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                debugPrint("Error injecting script: \(error.localizedDescription)")
            }
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()  // Hide the loader in case of error
        showAlert(message: "Failed to load the page: \(error.localizedDescription)")
    }
}


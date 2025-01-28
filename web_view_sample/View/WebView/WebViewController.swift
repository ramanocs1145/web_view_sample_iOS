import UIKit
import WebKit
import KRProgressHUD

class WebViewController: UIViewController {
    private weak var webView: WKWebView?
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
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
        let contentController = WKUserContentController()
        contentController.add(self, name: "iOSBridge")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.webView = webView
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL")
            return
        }
        self.webView?.load(URLRequest(url: url))
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
}
//MARK: - WKNavigationDelegate methods

extension WebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()  // Hide the loader once the page finishes loading
        let script = """
              console.log("Injecting JavaScript...");
              var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
              var eventer = window[eventMethod];
              var messageEvent = eventMethod === "attachEvent" ? "onmessage" : "message";
              
              eventer(messageEvent, function(e) {
                  console.log("Message received: ", e.data);
                  window.webkit.messageHandlers.iOSBridge.postMessage(e.data);
              }, false);
              """
        
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("Error injecting script: \(error.localizedDescription)")
            } else {
                print("JavaScript injected successfully")
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()  // Hide the loader in case of error
        showAlert(message: "Failed to load the page: \(error.localizedDescription)")
    }
    
}

//MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "iOSBridge" else { return }
        if let data = message.body as? String {
            handlePostMessage(data: data)
        } else {
            print("Invalid message format")
        }
    }
    
    private func handlePostMessage(data: String) {
        do {
            let jsonData = data.data(using: .utf8)!
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print("Received data: \(jsonObject)")
            
                if let pOrderId = jsonObject["p_order_id"] as? String, !pOrderId.isEmpty {
                    // Handle the payment status check
                    print("Payment Order ID: \(pOrderId)")
                    checkPaymentStatus(orderId: pOrderId)
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    private func checkPaymentStatus(orderId: String) {
        // Perform payment status check here
        print("Checking payment status for Order ID: \(orderId)")
        // Add your repository logic
    }
}


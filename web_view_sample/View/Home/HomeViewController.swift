//
//  HomeViewController.swift
//  web_view_sample
//
//  Created by RAMANATHAN PITCHAI on 20/01/25.
//

import UIKit
import KRProgressHUD

class HomeViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemMint
        button.setTitle("Fetch Orders", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupUI()
    }
    
    private func setupUI() {
        fetchButton.addTarget(self, action: #selector(fetchUserData), for: .touchUpInside)

        view.addSubview(fetchButton)
        
        NSLayoutConstraint.activate([
            
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fetchButton.widthAnchor.constraint(equalToConstant: 200),
            fetchButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
        
    @objc
    private func fetchUserData() {
        homeViewModel.fetchCreatedOrderDetails { [weak self] (result: Result<CreateOrdersSuccessResponse, Error>) in
            self?.hideLoader()  // Hide the loader after completion

            switch result {
            case .success(let ordersSuccessResponse):
                guard let iframeLink = ordersSuccessResponse.iframeLink else {
                    self?.showAlert(message: "Invalid response: iframe link not found.")
                    return
                }
                self?.navigateToWebView(with: iframeLink)

            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func navigateToWebView(with urlString: String) {
        let webViewController = WebViewController(urlString: urlString)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func showAlert(message: String) {
        AlertHelper.showAlert(on: self, message: message)
    }

    private func showLoader() {
        KRProgressHUD.showOn(self).show()
    }

    private func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            KRProgressHUD.dismiss()
        }
    }
}

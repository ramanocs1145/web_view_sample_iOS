//
//  AlertHelper.swift
//  web_view_sample
//
//  Created by EXAMPLE on 20/01/25.
//

import UIKit

class AlertHelper {
    static func showAlert(on viewController: UIViewController, title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}

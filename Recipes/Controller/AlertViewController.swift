//
//  AlertViewController.swift
//  Recipes
//
//  Created by Antoine Antoniol on 20/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit

    //  MARK: - Alert

extension UIViewController  {
    /// Show alert with custom message
    func showAlert(alert: AlertMessages, title: String) {
        let alertVC = UIAlertController(title:title , message: alert.rawValue , preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion:nil)
    }
}

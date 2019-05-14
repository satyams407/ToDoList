//
//  Utiity.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static func setupAlert(title: String, message: String, okAction: UIAlertAction?, cancelAction: UIAlertAction?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if let action = okAction {
            alert.addAction(action)
        }
        if let action = cancelAction {
            alert.addAction(action)
        }
        if okAction == nil && cancelAction == nil {
            //Fallback if no action provided.
            let action = UIAlertAction.init(title: StringConstants.okButtonTitle, style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(action)
        }
        
        return alert
    }
    
    static func showAlert(title: String, message: String, okAction: UIAlertAction?, cancelAction: UIAlertAction?, onController controller: UIViewController) {
        let alert = setupAlert(title: title, message: message, okAction: okAction, cancelAction: cancelAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showTextFieldAlert(alert: UIAlertController, textFieldHandler: ((UITextField) -> Void)?, onController controller: UIViewController) {
        alert.addTextField(configurationHandler: textFieldHandler)
        controller.present(alert, animated: true, completion: nil)
    }
}

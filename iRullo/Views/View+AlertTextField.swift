//
//  View+AlertTextField.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 21/10/23.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    
    func presentAlertTextField(title: String, 
                               message: String? = nil,
                               defaultTextFieldText: String? = nil,
                               confirmAction: @escaping (String?) -> ()) {
        
//        guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController else {
//            return
//        }
//        
////        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
////        alertController.addTextField { textField in
////            textField.text = defaultTextFieldText
////        }
////        alertController.addAction(.init(title: "Cancel", style: .cancel) { _ in })
////        alertController.addAction(.init(title: "Save", style: .default, handler: { _ in
////            guard let textField = alertController.textFields?.first else {
////                return
////            }
////            confirmAction(textField.text)
////        }))
//        rootVC.present(ViewDetailCard(), animated: true, completion: nil)
        
        
    }
}

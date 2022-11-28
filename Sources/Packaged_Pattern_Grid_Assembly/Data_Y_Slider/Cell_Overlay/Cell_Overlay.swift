//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import UIKit
import SwiftUI

class UICollection_View_Slight_Extension : UICollectionViewCell {
    
    func host<Content: View>(_ hostingController: UIHostingController<Content>) {
        
        backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        hostingController.view.accessibilityIdentifier = "blonk"
        addSubview(hostingController.view)

        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            hostingController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            hostingController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

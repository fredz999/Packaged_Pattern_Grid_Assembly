//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import UIKit
import SwiftUI

class UICollection_View_Base : UICollectionViewCell {
    
    func host<Content: View>(_ hostingController: UIHostingController<Content>) {
        
        backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
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

class UICollection_Cell_Overlay_Dispensor<InjectedOverlay:View> : ObservableObject {
    
    var injectedOverlay : InjectedOverlay?
    
    public func inject_Overlay(InjectedOverlayView: InjectedOverlay){
        injectedOverlay = InjectedOverlayView
    }
    
    @ViewBuilder func return_Overlay() -> some View {
        if let lclInjectedOverlay = injectedOverlay {
            lclInjectedOverlay
        }
    }
    
}


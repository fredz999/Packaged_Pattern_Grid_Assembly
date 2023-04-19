//
//  File.swift
//  
//
//  Created by Jon on 18/04/2023.
//

import Foundation
import SwiftUI
import UIKit

public class Data_Y_Slider_Coordinator<T:View> : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ObservableObject {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    public var vertical_Slider_Responders : [P_VSlider_Responder] = []

    public override init(){
        super.init()
    }
    
    public func addResponder(responderParam:P_VSlider_Responder){
        vertical_Slider_Responders.append(responderParam)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dimensions.DATA_final_Line_Y_Index
    }
    
    var parentWrapper : Wrapped_Data_Y_Slider<T>?

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("indexPath: ..................",indexPath.description)
        let vertical_Slider_Cell = Slider_Cell.getReusedCellFrom(collectionView: collectionView, cellForItemAt: indexPath)
        
        if let lclParentWrapper = parentWrapper {
            if vertical_Slider_Cell.has_BeenOverlayed == false {
                
                let newYelRec = lclParentWrapper.yield_A_Cell(indexPath: indexPath)
                let uicThing = UIHostingController(rootView: newYelRec)
                
                if let uiV = uicThing.view {
                    vertical_Slider_Cell.backgroundColor = .clear
                    uicThing.view.translatesAutoresizingMaskIntoConstraints = false
                    uicThing.view.backgroundColor = .clear
                    uiV.accessibilityIdentifier = "uiv"
                    vertical_Slider_Cell.addSubview(uiV)
                    let constraints = [
                        uicThing.view.topAnchor.constraint(equalTo: vertical_Slider_Cell.contentView.topAnchor, constant: 0),
                        uicThing.view.leftAnchor.constraint(equalTo: vertical_Slider_Cell.contentView.leftAnchor, constant: 0),
                        uicThing.view.bottomAnchor.constraint(equalTo: vertical_Slider_Cell.contentView.bottomAnchor, constant: 0),
                        uicThing.view.rightAnchor.constraint(equalTo: vertical_Slider_Cell.contentView.rightAnchor, constant: 0),
                    ]
                    NSLayoutConstraint.activate(constraints)
                    vertical_Slider_Cell.has_BeenOverlayed = true
                }
                
           }
        }
        return vertical_Slider_Cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if vertical_Slider_Responders.count > 0 {
            for res in vertical_Slider_Responders {
                res.react_To_Swiper_Y(y_OffsetParam: scrollView.contentOffset.y)
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = dimensions.ui_Unit_Width*3
        let height = dimensions.ui_Unit_Height
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public var v_Collection_View : UICollectionView?
    
    public func toggleFreeze(toFreeze : Bool) {
        if toFreeze == true {
            if let lclV_Collection_View = v_Collection_View {
                lclV_Collection_View.isScrollEnabled = false
            }
        }
        else if toFreeze == false {
            if let lclV_Collection_View = v_Collection_View {
                lclV_Collection_View.isScrollEnabled = true
            }
        }
    }

    func vertical_GoToEnd(){
        
//        let last = lclDimensions.useable_Data_Range_Upper_Limit-1
//        let indexToScrollTo = IndexPath(item: last, section: 0)
//        if let lclCollection_View = v_Collection_View {
//            lclCollection_View.scrollToItem(at: indexToScrollTo, at: .bottom, animated: false)
//        }
        
    }

}
//=========================================================================================================

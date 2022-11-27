//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import SwiftUI
import UIKit

public class Vertical_Slider_Coordinator_Store : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ObservableObject {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    public var vertical_Slider_Responders : [P_VSlider_Responder] = []
    
    // have to do this in a class outside of here because its way more convoluted than it should be
    // var uICollection_Cell_Overlay_Dispensor = UICollection_Cell_Overlay_Dispensor<UICollection_Cell_Overlay>()
    //var parentContainerRef : Generic_Central_And_Sliders_Factory?
    
    
    
    public override init(){
        super.init()
    }
    
//    public func data_Y_Slider_Cell_Factory_Method(data_Y_Slider_Cell_Factory_Method: (()->Injected_Data_Y_Slider_Cell_Type))->some View{
//        return data_Y_Slider_Cell_Factory_Method()
//    }
    
//    var data_Y_Slider_Cell_Factory_Method : (()->Injected_Data_Y_Slider_Cell_Type)?
//
//    public func injectCellFactoryMethod(methodParam: @escaping (()->Injected_Data_Y_Slider_Cell_Type)){
//        data_Y_Slider_Cell_Factory_Method = methodParam
//    }
    
    public func addResponder(responderParam:P_VSlider_Responder){
        vertical_Slider_Responders.append(responderParam)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dimensions.DATA_final_Line_Y_Index
    }
    
    var parentWrapper : Wrapped_Vertical_Slider?

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let vertical_Slider_Cell = Slider_Cell.getReusedCellFrom(collectionView: collectionView, cellForItemAt: indexPath)
        
//        if let lclparentContainerRef = parentContainerRef{
//            vertical_Slider_Cell.host(UIHostingController(rootView: lclparentContainerRef.data_Y_Slider_uICollection_Cell_Overlay_Dispensor.return_Overlay()))
//        }
        //Default_UICollection_Cell_Overlay
        
//        if let lclData_Y_Slider_Cell_Factory_Method = data_Y_Slider_Cell_Factory_Method {
//            vertical_Slider_Cell.host(UIHostingController(rootView: lclData_Y_Slider_Cell_Factory_Method()   ))
//        }
//        else if data_Y_Slider_Cell_Factory_Method == nil {
//            vertical_Slider_Cell.host(UIHostingController(rootView:  Default_UICollection_Cell_Overlay(numz: indexPath.item)))
//        }
        
        
        //vertical_Slider_Cell.host(UIHostingController(rootView:  Default_UICollection_Cell_Overlay(numz: indexPath.item)))
        //yield_A_Cell
        if let lclParent = parentWrapper{
            vertical_Slider_Cell.host(UIHostingController(rootView:  lclParent.yield_A_Cell(indexNum: indexPath.item) ))
        }
        
        
        //vertical_Slider_Cell.host(UIHostingController(rootView: uICollection_Cell_Overlay_Dispensor.return_Overlay()     ))
        //UICollection_Cell_Overlay(numz: indexPath.item)
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
        let width = dimensions.ui_Unit_Width
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
    
    //let lclDimensions = ComponentDimensions.StaticComponentDimensions
    
    func vertical_GoToEnd(){
        
//        let last = lclDimensions.useable_Data_Range_Upper_Limit-1
//        let indexToScrollTo = IndexPath(item: last, section: 0)
//
//        if let lclCollection_View = v_Collection_View {
//            lclCollection_View.scrollToItem(at: indexToScrollTo, at: .bottom, animated: false)
//        }
        
    }

}

// howwwwww do I get the thingy
public class Wrapped_Vertical_Slider {
    let dimensions = ComponentDimensions.StaticDimensions
    var vertical_Slider_Coordinator : Vertical_Slider_Coordinator_Store
    var vertical_Slider_Responder_Store : Vertical_Slider_Responder_Store
    //var cellDispensor : UICollection_Cell_Overlay_Dispensor = UICollection_Cell_Overlay_Dispensor()
    
    public init() {
        self.vertical_Slider_Coordinator = Vertical_Slider_Coordinator_Store()
        self.vertical_Slider_Responder_Store = Vertical_Slider_Responder_Store()
        self.vertical_Slider_Coordinator.addResponder(responderParam: self.vertical_Slider_Responder_Store)
        
        self.vertical_Slider_Coordinator.parentWrapper = self
    }
    
    

    func yield_A_Cell(indexNum:Int)->some View{
        return Default_UICollection_Cell_Overlay(numz:indexNum)
    }
    
    @ViewBuilder public func returnData_Y_Slider() -> some View {
//        if let lclInjected_Data_Y_Slider_Cell_View = injected_Data_Y_Slider_Cell_View {
//            lclInjected_Data_Y_Slider_Cell_View
//        }
//        else if injected_Data_Y_Slider_Cell_View == nil {
            Data_Vertical_Slider_View(vertical_Slider_Coordinator_Param: vertical_Slider_Coordinator)
            .frame(width: dimensions.ui_Unit_Width,height: dimensions.Vert_Cursor_Slider_Height)
        //}
    }
}

struct Default_UICollection_Cell_Overlay : View {
    @State var numz : Int = 0
    var body: some View {
        return ZStack(alignment: .topLeading){
            Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0.6))
            Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 1, green: 0, blue: 1))
            Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 1, green: 0, blue: 1))
            Text(numz.description).foregroundColor(.white)
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jon on 27/11/2022.
//

import Foundation
import SwiftUI
import UIKit

public struct Generic_Slider_View<T:View>: UIViewRepresentable {

    public var v_Slider_Data : [Int] = []
    
    public var generic_Slider_Coordinator : Generic_Slider_Coordinator<T>

    public init(generic_Slider_Coordinator_Param : Generic_Slider_Coordinator<T>){
        generic_Slider_Coordinator = generic_Slider_Coordinator_Param
        let vSliderStart : Int = 0
        let vSliderEnd : Int = 64
        for i in vSliderStart..<vSliderEnd {
            v_Slider_Data.append(i)
        }
    }

    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        context.coordinator.v_Collection_View = collectionView
        Slider_Cell.registerWithCollectionView(collectionView: collectionView)
        return collectionView
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        //
    }

    public func makeCoordinator() -> Generic_Slider_Coordinator<T> {
        return generic_Slider_Coordinator
    }
    
}

public class Generic_Slider_Coordinator<T:View> : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ObservableObject {
    
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
    
    var parentWrapper : Wrapped_Vertical_Slider<T>?{
        didSet{
            if let lclParentWrapper = parentWrapper{
                print("lclParentWrapper: ",lclParentWrapper)
            }
            else if parentWrapper == nil{
                print("lclParentWrapper: wuz nillll")
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView called: parentWrapper was:",parentWrapper == nil ? ", nil" : ", not nil")
        let vertical_Slider_Cell = Slider_Cell.getReusedCellFrom(collectionView: collectionView, cellForItemAt: indexPath)

        if let lclParent = parentWrapper{
            vertical_Slider_Cell.host(UIHostingController(rootView:  lclParent.yield_A_Cell(indexNum: indexPath.item) ))
        }
//        else if parentWrapper == nil{
//            print("parentWrapper appears to have been nil")
//        }

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
public class Wrapped_Vertical_Slider<T:View> {
    let dimensions = ComponentDimensions.StaticDimensions
    var generic_Slider_Responder_Store : Generic_Slider_Responder_Store
    var generic_Slider_coordinator : Generic_Slider_Coordinator<T>
    
    
    public init() {
        
        self.generic_Slider_Responder_Store = Generic_Slider_Responder_Store()
        
        self.generic_Slider_coordinator = Generic_Slider_Coordinator<T>()
        self.generic_Slider_coordinator.addResponder(responderParam: self.generic_Slider_Responder_Store)
        self.generic_Slider_coordinator.parentWrapper = self
        
    }
    
    func yield_A_Cell(indexNum:Int)->some View {
        return Default_UICollection_Cell_Overlay(numz:indexNum)
    }
    
    @ViewBuilder public func returnData_Y_Slider() -> some View {
//        Data_Vertical_Slider_View(vertical_Slider_Coordinator_Param: vertical_Slider_Coordinator)
//        .frame(width: dimensions.ui_Unit_Width,height: dimensions.Vert_Cursor_Slider_Height)
        Generic_Slider_View(generic_Slider_Coordinator_Param: Generic_Slider_Coordinator<Default_UICollection_Cell_Overlay>())
        .frame(width: dimensions.ui_Unit_Width,height: dimensions.Vert_Cursor_Slider_Height)
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


class Generic_Slider_Responder_Store : ObservableObject, P_VSlider_Responder {
    let centralState = Central_State.Static_Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    
    var trackedInt : Int {
        didSet {
            centralState.data_Slider_LowBracket_Update(newLower: trackedInt)
        }
    }
    
    init(){
        trackedInt = 0
    }

    func react_To_Swiper_Y(y_OffsetParam: CGFloat) {
        let bracketFloat = y_OffsetParam/dimensions.ui_Unit_Height
        let bracketInt = Int(bracketFloat)
        if bracketInt != trackedInt, bracketInt >= 0, bracketInt <= dimensions.DATA_final_Line_Y_Index {
            trackedInt = bracketInt
        }
        else if bracketInt < 0,trackedInt != 0{trackedInt = 0}
        else if bracketInt > dimensions.DATA_final_Line_Y_Index
        , trackedInt != dimensions.DATA_final_Line_Y_Index{trackedInt = dimensions.DATA_final_Line_Y_Index}
    }

}

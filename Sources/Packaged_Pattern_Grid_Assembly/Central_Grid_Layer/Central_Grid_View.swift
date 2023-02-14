//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

//public struct Central_Grid_View : View {
//     
//    public var central_Grid_Store : Central_Grid_Store
//    public init(grid_Store_Param : Central_Grid_Store){
//        central_Grid_Store = grid_Store_Param
//    }
//    
//    public var body: some View {
//        return ZStack(alignment: .topLeading){
//            
//            
//            // this section has to come from a viewBuilder that uses the injected types
//            ForEach(central_Grid_Store.vis_Line_Store_Array){ lineStore in
//                ForEach(lineStore.visual_Cell_Store_Array){ cellStore in
//                    if let lclCellXFloat = cellStore.xFloat, let lclCellYFloat = cellStore.yFloat{
//                        Default_Central_Cell_View(central_Cell_Store: cellStore).offset(x:lclCellXFloat,y:lclCellYFloat)
//                    }
//                }
//            }
//            
//            
//            
//        }
//    }
//}
//
//public struct Default_Central_Cell_View : View {
//    
//    @StateObject public var central_Cell_Store : Central_Cell_Store
//    public var body: some View {
//        return ZStack(alignment: .topLeading){
//            
//            
//                //if let lclUnderlyingData = central_Cell_Store.underlying_Data_Cell{
//            
//                    
////                    Data_Cell_Display_View<Default_Unassigned_View,Default_Start_View,Default_Mid_View,Default_End_View,Default_Single_View>(
////                        current_Data_Vals_Holder: central_Cell_Store.data_Vals_Holder
////                        , unassigned_View: Default_Unassigned_View()
////                        , start_View: Default_Start_View(current_Underlying_Data_Param: central_Cell_Store.data_Vals_Holder)
////                        , mid_View: Default_Mid_View(current_Underlying_Data_Param: central_Cell_Store.data_Vals_Holder)
////                        , end_View: Default_End_View(current_Underlying_Data_Param: central_Cell_Store.data_Vals_Holder)
////                        , single_View: Default_Single_View(current_Underlying_Data_Param: central_Cell_Store.data_Vals_Holder))
//                    
//    
//                //}
//        }
//    }
//}

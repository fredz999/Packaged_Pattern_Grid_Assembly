//
//  Multi_Select_Helper.swift
//  
//
//  Created by Jon on 14/03/2023.
//

import Foundation
import SwiftUI

//P_Selectable_Mode
class Multi_Select_Helper : P_Selectable_Mode {
    
    var parentCentralState : Central_State
    
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false{mode_Active = true}
    }

    func deactivate_Mode() {
        if mode_Active == true { mode_Active = false }
    }
    
    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }
}

// just going to use a seperate multi select mode for now ....
// the single select can just be a hover over one note type thing

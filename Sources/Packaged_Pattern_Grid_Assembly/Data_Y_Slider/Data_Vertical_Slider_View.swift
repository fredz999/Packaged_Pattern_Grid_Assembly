//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import SwiftUI
import UIKit

public struct Data_Vertical_Slider_View: UIViewRepresentable {

    public var v_Slider_Data : [Int] = []
    
    public var vertical_Slider_Coordinator_Store : Vertical_Slider_Coordinator_Store

    public init(vertical_Slider_Coordinator_Param : Vertical_Slider_Coordinator_Store){
        vertical_Slider_Coordinator_Store = vertical_Slider_Coordinator_Param
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

    public func makeCoordinator() -> Vertical_Slider_Coordinator_Store {
        return vertical_Slider_Coordinator_Store
    }
    
}

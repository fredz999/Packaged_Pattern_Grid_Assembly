//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import SwiftUI
import UIKit

//class Slider_Cell : UICollection_View_Slight_Extension {
class Slider_Cell : UICollection_View_Other_Extension {

    private static let reuseId = "SliderCell"

    public var labelText = 0
    
    var optionalAddView : UIView?

    static func registerWithCollectionView(collectionView: UICollectionView) {
        collectionView.register(Slider_Cell.self, forCellWithReuseIdentifier: reuseId)
    }

    static func getReusedCellFrom(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollection_View_Other_Extension{
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Slider_Cell
    }

    var Cell_Info_View: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        let dimensions = ComponentDimensions.StaticDimensions
        super.init(frame: frame)
        contentView.addSubview(self.Cell_Info_View)
        
        Cell_Info_View.text = "\(self.labelText)"
        Cell_Info_View.textAlignment = .center
        Cell_Info_View.font = UIFont(name: "Helvetica Bold", size: dimensions.cellFontSize)
        Cell_Info_View.translatesAutoresizingMaskIntoConstraints = false

        Cell_Info_View.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        Cell_Info_View.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        Cell_Info_View.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        Cell_Info_View.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
//        let newYelRec = YelRec()
//        let uicThing = UIHostingController(rootView: newYelRec)
//        contentView.addSubview(uicThing.view)

        self.isSelected = false //true
    }
    
    
    

    func update() {
        Cell_Info_View.text = "\(self.labelText)"
    }
    
    override func prepareForReuse() {
        print("prepareForReuse at least called")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
// haaaaaaw du aaah get theeis eeen from aatseeeeeide?
struct YelRec : View{
    init(){
        print("YelRec")
    }
    var body: some View{
        return ZStack(alignment: .topLeading){
            Rectangle().frame(width: 30,height: 30).foregroundColor(.yellow)
            Circle().frame(width: 30,height: 30).foregroundColor(.purple)
        }
    }
}

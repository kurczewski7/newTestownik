//
//  PictureLibrary.swift
//  testownik
//
//  Created by Sławek K on 22/03/2022.
//  Copyright © 2022 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit

class PictureLibrary {
    typealias PictType = [String : Int]
    
    var pictureList: [PictType]? = nil
    var count: Int {
        get {      return pictureList?.count ?? 0            }
    }
    func add( _ pictElem: PictType.Value) {
        
        let xx: PictType.Value = 55
        print("xx:\(xx)")
        //for (key, value) in pictureList?.enumerated()
        //capitalCity["Japan"] = "Tokyo"
        //capitalCity["Japan"] = "Tokyo"
        //pictureList?.enumerated()
        
    }
    func giveAsData(_ name: String)  -> Data? {
        let dataTmp = UIImage(named: name) //PictType.Value()
        return dataTmp?.pngData()
    }
    func giveAsImage(_ name: String)  -> UIImage? {
        let dataTmp = UIImage(named: name)
        return dataTmp
    }
    
    func wwww() {
        let pic1 = UIImage(named: "001.png")
        //var
        //add(<#T##pictElem: PictType##PictType#>)
        let  a = giveAsData("aaa")
    }
}

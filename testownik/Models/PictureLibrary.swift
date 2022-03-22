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
    typealias PictType = [String : Data]
    
    var pictureList: [PictType]? = nil
    var count: Int {
        get {      return pictureList?.count ?? 0            }
    }
    func add( _ pictElem: PictType) {
        
    }
    func giveAsData(_ name: String)  -> Data? {
        let dataTmp = Data()
        
        return dataTmp
    }
    func giveAsImage(_ name: String)  -> UIImage? {
        let dataTmp = UIImage()
        
        return dataTmp
    }
    
    func wwww() {
        let  a = giveAsData("aaa")
    }
}

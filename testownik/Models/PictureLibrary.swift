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
    
    var pictureList: PictType = [:]
    var count: Int {
        get {      return pictureList.count         }
    }
    private func add(forName key: PictType.Key, value: PictType.Value) {
        pictureList[key] = value
    }
    func addData(forName key: String, value: Data?) {
        if let val = value {
            add(forName: key, value: val)
        }
    }
    func addUImage(forName key: String, value: UIImage?) {
        if let val = value, let data = val.pngData() {
            add(forName: key.lowercased(), value: data)
        }
    }
    func removeAll() {
        pictureList.removeAll()
    }
    func giveAsData(_ name: String)  -> Data? {
        return pictureList[name]
    }
    func giveAsImage(_ name: String)  -> UIImage? {
        var image: UIImage? = nil
        if let tmpData = pictureList[name.lowercased()] {
            image = UIImage(data: tmpData)
        }
        return  image
    }
    func give(forName key: PictType.Key) -> PictType.Value? {
        return pictureList[key.lowercased()]
    }    
    func giveDemoImage(_ name: String = "001.png") -> UIImage? {
        return  UIImage(named: name)
    }
}

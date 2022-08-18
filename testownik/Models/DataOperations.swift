//
//  GenericData.swift
//  testownik
//
//  Created by Slawek Kurczewski on 27/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//
import Foundation

class DataOperations {
    typealias T = Test
    private var  genericArray = [T]()
    var testList: [T] {
       get {   return genericArray   }
       set {   genericArray = newValue  }
    }
    var count: Int {
        get {   return genericArray.count   }
    }
    var isEmpty: Bool {
        get { genericArray.count == 0 } }
    var notEmpty: Bool {
        get { genericArray.count > 0 } }
    var currentTest: Int = 0
    
    subscript(index: Int) -> T {
        get {  //_ = isIndexInRange(index: index)
            let isValid = isIndexValid(index: index)
            assert(isValid, "ERROR!!: Index \(index) is bigger then count \(count). Give correct index!")
            return genericArray[index]
        }
       set {   //_ = isIndexInRange(index: index)
            assert(isIndexValid(index: index), "ERROR!!: Index \(index) is bigger then count \(count). Give correct index!")
            genericArray[index] = newValue
        }
    }
    func clearData() {
        currentTest = 0
        genericArray.removeAll()
    }
    func isIndexValid(index: Int) -> Bool  {
        return index >= 0 && index < count
    }
    func isIndexInRange(index: Int, isPrintToConsol: Bool = true) -> Bool {
        if index >= count {
            if isPrintToConsol {
               print("Index \(index) is bigger then count \(count). Give correct index!")
            }
            return false
        }
        else {
            return true
        }
    }
    func getCurrent() -> T {
         return genericArray[currentTest]
    }
    func first() {
        currentTest = 0
    }
    func last() {
       currentTest = count-1
    }
    func next() {
        if currentTest+1 < count {
            currentTest += 1
        }
    }
    func previous() {
        if currentTest > 0 && currentTest < count {
            currentTest -= 1
        }
    }    
    func add(value: T) -> Int {
        genericArray.append(value)
        return genericArray.count
    }
    func remove(at row: Int) -> Bool {
        if row < genericArray.count {
            genericArray.remove(at: row)
            return true
        }
        else {
            return false
        }
    }
    func forEach(executeBlock: (_ index: Int, _ oneElement: T?) -> Void) {
         var i = -1
         print("genericArray.count:\(genericArray.count)")
         for elem in genericArray {
             i += 1
             executeBlock(i, elem)
         }
     }
     func findValue(procedureToCheck: (_ oneElement: T?) -> Bool) -> Int {
         var i = -1
         for elem in genericArray {
             i += 1
             if procedureToCheck(elem) {
                 print("Object fond in table row \(i)")
                 return i
             }
         }
         print("Object not found in table")
         return -1
     }
}

//
//  TestToDo.swift
//  testownik
//
//  Created by Sławek K on 10/05/2022.
//  Copyright © 2022 Slawomir Kurczewski. All rights reserved.
//

import Foundation
class TestToDo {
    struct TestInfo {
        let fileNumber: Int
        let groupNr: Int
        let errorReapad: Int
        let reapadNr: Int
        let checked: Bool
        let extra: String // ???
    }
    struct RawTest {
        let fileNumber: Int
        var checked: Bool = false
    }
    var groupSize: Int = 30
    var reapeadTest: Int = 30
    private var rawTests: [RawTest] = [RawTest]()
    private var mainTests: [RawTest] = [RawTest]()
    private var extraTests: [RawTest] = [RawTest]()
    
    
    init(rawTestList: [Int]) {
        for i in 0..<rawTestList.count {
            let tmpElem = RawTest(fileNumber: rawTestList[i])
            self.rawTests.append(tmpElem)
        }
    }
    func getNext()  -> Int? {
        let retVal = 0

        return retVal
    }
    func getPrev()  -> Int? {
        let retVal = 0
        return retVal
    }
    func lotteryMainTests(fromFilePosition startPos: Int, arraySize size: Int ) -> [Int]    {
        mainTests.removeAll()
        for i in 0..<size {
            if startPos + i == rawTests.count {   break   }
            mainTests.append(rawTests[startPos + i])
        }
        for el in mainTests {
            print("\(el.fileNumber)")
        }
        mainTests = mixTests(inputElements: &mainTests)
        for el in mainTests {
            print("\(el.fileNumber)")
        }

        
        
//        let pos = Setup.randomOrder(toMax: size)
//        guard startPos + pos < rawTests.count  else {   return [Int]()   }
//        if let elem = rawTests[startPos + pos] {
//
//        }
       return [Int]()
    }
    func mixTests(inputElements inputTst: inout [RawTest] ) -> [RawTest] {
        var outputTst: [RawTest] = [RawTest]()
        let countElem = inputTst.count
        for _ in 0..<countElem {
            let pos = Setup.randomOrder(toMax: inputTst.count)
            let elem = inputTst[pos]
            inputTst.remove(at: pos)
            outputTst.append(elem)
        }
        return outputTst
    }
    func loteyExtraTests() {
        
    }

}

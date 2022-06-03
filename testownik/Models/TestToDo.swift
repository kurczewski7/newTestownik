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
        var isExtraTest: Bool
        var checked: Bool = false
    }

    var groups: Int = 0
    var groupSize: Int = 30
    var reapeadTest: Int = 5
    var currentPosition = 0
    
    private var mainCount: Int = 0
    private var extraCount: Int = 0
    private var rawTests: [RawTest] = [RawTest]()
    private var mainTests: [[RawTest]] = [[RawTest]]()
    private var extraTests: [[RawTest]] = [[RawTest]]()
    
    var count: Int {
        get {
            return self.mainCount + self.extraCount
        }
    }
    //var twoDimensionArray: [[RawTest]] = [[RawTest]]()
        
    init(rawTestList: [Int]) {
        for i in 0..<rawTestList.count {
            let tmpElem = RawTest(fileNumber: rawTestList[i], isExtraTest: false)
            self.rawTests.append(tmpElem)
        }
        groups = Int(rawTests.count / groupSize)
        groups += (groups * groupSize == rawTests.count ? 0 : 1)
        fillMainTests()
        fillExtraTests()
    }
    subscript(index: Int)  -> RawTest? {
        return getElem(numberFrom0: index)
    }
    subscript(group: Int, position: Int) ->  RawTest? {
    guard   group < self.groups, position < mainTests[group].count else {  return nil  }
        if position <= self.groupSize {
            return mainTests[group][position]  }
        else    {
            return mainTests[group][position - self.groupSize]  }
    }
    func getFirst()  -> RawTest? {
        currentPosition = 0
        return getElem(numberFrom0: currentPosition)
    }
    func getLast() -> RawTest? {
        currentPosition = count - 1
        return getElem(numberFrom0: currentPosition)
    }
    func getNext()  -> RawTest? {
        currentPosition += 1
        return getElem(numberFrom0: currentPosition)
    }
    func getPrev()  -> RawTest? {
        currentPosition -= 1
        guard currentPosition >= 0 else {  return nil  }
        return getElem(numberFrom0: currentPosition)
    }
    func addExtra(forNewTest: RawTest) {
        
    }
    func addExtra(forNumerTest number: Int) {
        //let xx = rawTests.map(<#T##transform: (RawTest) throws -> T##(RawTest) throws -> T#>)
        
    }
    private func fillMainTests() {
        mainCount = 0
        for j in 0..<groups {
            let emptyArray = [RawTest]()
            mainTests.append(emptyArray)
            let testsList = lotteryMainTests(fromFilePosition: j*groupSize, arraySize: groupSize)
            mainTests[j].append(contentsOf: testsList)
            mainCount += testsList.count
        }
    }
    private func fillExtraTests()   {
        extraCount = 0
        //var newTests: [RawTest] = [RawTest]()
        //newTests.removeAll()
        for i in 0..<groups {
            let emptyArray = [RawTest]()
            extraTests.append(emptyArray)
            var row = mainTests[i]
            row = mixTests(inputElements: &row, count: reapeadTest)
            extraTests[i].append(contentsOf: row)
            extraCount += row.count
        }
    }
    func getElem(numberFrom0: Int) -> RawTest? {
        var retVal: RawTest = RawTest(fileNumber: 0, isExtraTest: false)
        let numberFrom1 = numberFrom0 + 1
        let fullSize = groupSize + reapeadTest
        let currentGroup = Int(numberFrom1 / fullSize) + (numberFrom1 % fullSize > 0 ? 1 : 0)
        guard numberFrom0 < self.count, currentGroup <= groups else {      return nil   }
        let positionInGroup = numberFrom1 - ((currentGroup - 1) * fullSize)
        if positionInGroup <= groupSize {
            retVal = mainTests[currentGroup - 1][positionInGroup - 1]
            retVal.isExtraTest = false
        }
        else {
            retVal = extraTests[currentGroup - 1][positionInGroup - groupSize - 1]
            retVal.isExtraTest = true
        }
        return retVal
    }
    private func lotteryMainTests(fromFilePosition startPos: Int, arraySize size: Int ) -> [RawTest]    {
        var newTests: [RawTest] = [RawTest]()
        newTests.removeAll()
        for i in 0..<size {
            if startPos + i == rawTests.count {   break   }
            newTests.append(rawTests[startPos + i])
        }
        print("befor")
        for el in newTests {
            print("\(el.fileNumber)")
        }
        newTests = mixTests(inputElements: &newTests)
        print("after")
        for el in newTests {
            print("\(el.fileNumber)")
        }
       return newTests
    }
    private func mixTests(inputElements inputTst: inout [RawTest], count: Int = -1) -> [RawTest] {
        var outputTst: [RawTest] = [RawTest]()
        let countElem = inputTst.count
        for i in 0..<countElem {
            if i == count {
                break
            }
            let pos = Setup.randomOrder(toMax: inputTst.count)
            let elem = inputTst[pos]
            inputTst.remove(at: pos)
            outputTst.append(elem)
        }
        return outputTst
    }
}

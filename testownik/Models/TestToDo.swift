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
        var errorCorrect: Bool = false
    }
    var groups: Int = 0
    var groupSize: Int = 30
    var reapeadTest: Int = 5
    var currentPosition = 0
    
    private var mainCount: Int = 0
    private var extraCount: Int = 0
    private var rawTests: [RawTest] = [RawTest]()
    
    var mainTests: [[RawTest]] = [[RawTest]]()
    var extraTests: [[RawTest]] = [[RawTest]]()
    var count: Int {
        get {
            return self.mainCount + self.extraCount
        }
    }
        
    init(rawTestList: [Int]) {
        for i in 0..<rawTestList.count {
            let tmpElem = RawTest(fileNumber: rawTestList[i], isExtraTest: false)
            self.rawTests.append(tmpElem)
        }
        groups = Int(rawTests.count / groupSize) + (rawTests.count % groupSize == 0 ? 0 : 1 )
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
    func getGroup(forNumerTest number: Int) -> Int? {
        var retVal: Int? = nil
        for i in 0..<self.groups {
            if mainTests[i].contains(where: {  $0.fileNumber == number  }) {
                retVal = i
                break
            }
        }
        return retVal
    }
    func add(forFileNumber number: Int, errorCorrect: Bool = true) {
        guard let foundGroup = getGroup(forNumerTest: number) else { return   }
        var row = extraTests[foundGroup]
        addExtra(forRow: &row, fileNumber: number, errorCorrect: errorCorrect)
        swapWhenDupplicate(forRow: &row, currentGroup: foundGroup)
        extraTests[foundGroup] = row
    }
    func addExtra(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
        let dupicArray = row.filter { $0.fileNumber == number && $0.errorCorrect }
        guard dupicArray.count == 0 else {
            if let position = findPosition(forRow: row, fileNumber: number) {   row[position].errorCorrect = true      }
            return
        }
        let oneTest = RawTest(fileNumber: number, isExtraTest: true, checked: false, errorCorrect: errorCorrect)
        let fileNumbersToDelete = row.filter { !$0.errorCorrect }
        if fileNumbersToDelete.count > 0 {
            if let newPosition = findPosition(forRow: row, fileNumber: fileNumbersToDelete[0].fileNumber) {
                row[newPosition] = oneTest
            }
        }
        else {
            row.append(oneTest)
            row.remove(at: row.count - 1)
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
    func reorganizeExtra(forRow row: inout [RawTest], fileNumber: Int, hawMenyTimes number: Int = 30) {
        let tt = TestToDo.RawTest(fileNumber: fileNumber, isExtraTest: false, checked: false, errorCorrect: false)
        guard !isSortingOk(forRow: &row) || row[0].fileNumber == fileNumber else {   return     }
        for _ in 0..<number {
            reSorting(previousElem: tt, forRow: &row)
            if row[0].fileNumber == fileNumber {
                cyclicShift(forRow: &row)
             }
            if isSortingOk(forRow: &row) && row[0].fileNumber != fileNumber {   break    }
            mixTests(inputElements: &row)
        }
        if row[0].fileNumber == fileNumber {
            cyclicShift(forRow: &row)
        }
    }
    func isSortingOk(forRow row: inout [RawTest])  -> Bool {
        var retVal = true
        for i in 0..<row.count - 1 {
            if row[i].fileNumber == row[i+1].fileNumber {
                retVal = false
                break
            }
        }
        return retVal
    }
    func changeQueue(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
        var newRow: [RawTest] = [RawTest]()
        guard row.count > 0 else {   return   }
        for i in 0..<row.count {
            if row[i].fileNumber != number {
                newRow.append(row[i])
                row.remove(at: i)
                break
            }
        }
        isertAtEnd(fromRow: &row ,toRow: &newRow)
        insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
        if row.count > 0 {
            for _ in 0..<5 {
                let oldCount = row.count
                insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
                if row.count == oldCount || row.count == 0 {
                    break
                }
            }
        }
        if  row.count > 0 {
            newRow.append(contentsOf: row)
            row.removeAll()
        }
        row = newRow
    }
    //======================================
    // Private methods
    private func insertBetween(fromRow row: inout [RawTest], toRow newRow: inout [RawTest], fileNumber number: Int) {
        var setToDelete = Set([Int]())
        for pos in 0..<row.count {
            let tmp = row[pos]
            for j in 0..<newRow.count {
                guard row.count > 0 && newRow.count > j else {    continue    }
                if j == newRow.count - 1 {
                    if newRow[j].fileNumber != tmp.fileNumber {
                        newRow.append(tmp)
                        setToDelete.insert(pos)
                    }
                    break
                }
                if j == 0  &&  tmp.fileNumber != number  &&  newRow[j].fileNumber != tmp.fileNumber {
                    newRow.insert(tmp, at: j)
                    setToDelete.insert(pos)
                    break
                }
                if  newRow[j].fileNumber != tmp.fileNumber && newRow[j+1].fileNumber != tmp.fileNumber {
                    newRow.insert(tmp, at: j+1)
                    setToDelete.insert(pos)
                    break
                }
            }
        }
        let tabToDelete = setToDelete.sorted {$0 > $1}
        for poz in tabToDelete {
            row.remove(at: poz)
        }
    }
    private func isertAtEnd(fromRow row: inout [TestToDo.RawTest], toRow newRow: inout [TestToDo.RawTest]) {
        var setToDelete = Set([Int]())
        let couuntRec = row.count
        for pos in 0..<couuntRec {
            if newRow[newRow.count-1].fileNumber != row[pos].fileNumber {
                newRow.append(row[pos])
                setToDelete.insert(pos)
            }
        }
        let tabToDelete = setToDelete.sorted {$0 > $1}
        for pos in tabToDelete {
            row.remove(at: pos)
        }
    }

    private func findPosition(forRow row: [RawTest], fileNumber number: Int) -> Int? {
            for (index, value) in row.enumerated() {
                if value.fileNumber == number {   return index    }
            }
        return nil
    }
    private func cyclicShift(forRow row: inout [RawTest]) {
        let tmp = row[0]
        row.remove(at: 0)
        row.append(tmp)
    }
    private func swapWhenDupplicate(forRow row: inout [RawTest],  currentGroup groupNo: Int) {
        guard groupNo < groups, mainTests[groupNo].count > 0, row.count > 2, mainTests[groupNo][mainTests.count-1].fileNumber == row[0].fileNumber else { return   }
        //var tmp = extraTests[groupNo]
        let oneTest = row[1]
        row.remove(at: 1)
        row.insert(oneTest, at: 0)
        extraTests[groupNo] = row
    }
    private func reSorting(previousElem: RawTest, forRow row: inout [RawTest]) {
        var errList: [Int] = [Int]()
        row.sort { !$0.errorCorrect  &&  $1.errorCorrect }
        row.sort {
            if $0.fileNumber == $1.fileNumber  {  errList.append($0.fileNumber) }
            return true
        }
    }
    private func fillMainTests() {
        self.mainCount = 0
        for j in 0..<groups {
            let emptyArray = [RawTest]()
            mainTests.append(emptyArray)
            let testsList = lotteryMainTests(fromFilePosition: j*groupSize, arraySize: groupSize)
            mainTests[j].append(contentsOf: testsList)
            mainCount += testsList.count
        }
    }
    private func fillExtraTests()   {
        self.extraCount = 0
        for i in 0..<groups {
            let emptyArray = [RawTest]()
            extraTests.append(emptyArray)
            var row = mainTests[i]
            mixTests(inputElements: &row, count: reapeadTest)
            swapWhenDupplicate(forRow: &row, currentGroup: i)
            extraTests[i].append(contentsOf: row)
            extraCount += row.count
        }        
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
        mixTests(inputElements: &newTests)
        print("after")
        for el in newTests {
            print("\(el.fileNumber)")
        }
       return newTests
    }
    private func mixTests(inputElements inputTst: inout [RawTest], count: Int = -1)  {
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
        inputTst = outputTst
    }
}

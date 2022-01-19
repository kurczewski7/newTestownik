//
//  Ratings.swift
//  testownik
//
//  Created by Slawek Kurczewski on 13/11/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation

class TestResult {
    var errorMultiple = 2
    private(set) var fileNumber: Int  // Not to modyfy
    private(set) var goodAnswers = 777
    private(set) var wrongAnswers = 666
    var correctionsToDo = 0
    var repetitionsToDo = 0
    var lastAnswer: Bool {
        didSet {
            if lastAnswer {
                self.goodAnswers += 1
                if self.correctionsToDo == 0 {
                    self.repetitionsToDo -= (self.repetitionsToDo > 0 ? 1 : 0)
                }
                else {
                    self.correctionsToDo -= 1
                }
            }
            else {
                self.wrongAnswers += 1
                self.correctionsToDo += errorMultiple
            }
        }
    }

    init(_ fileNumber: Int, lastAnswer: Bool) {
        self.fileNumber = fileNumber
        self.lastAnswer = lastAnswer
    }
    func resetAnswer() {
        self.goodAnswers = 0
        self.wrongAnswers = 0
    }
    func resetAll() {
        self.goodAnswers = 0
        self.wrongAnswers = 0
        self.correctionsToDo = 0
        self.repetitionsToDo = 0
    }
    func setFileNumber(_ fileNumber: Int ) {
        self.fileNumber = fileNumber
        
    }
    func setWrongAnswers(_ wrongAnswers: Int ) {
        self.wrongAnswers = wrongAnswers
    }
    func setGoodAnswers(_ goodAnswers: Int ) {
        self.goodAnswers = goodAnswers
    }

}
//----------------
class Ratings {
    var testList: [Int] = [4,2,4,2,1,7]
    //                     2,1,2,1,0,3
    var results = [ TestResult(1, lastAnswer: false),
                    TestResult(2, lastAnswer: false),
                    TestResult(4, lastAnswer: true),
                    TestResult(7, lastAnswer: true)]    //[TestResult]()
    
    
    var currentTest = 0
    var count: Int {
        get {    return testList.count    }
    }
    subscript(index: Int) -> TestResult? {
        get {
            guard index < self.testList.count  else {   return nil  }
            self.currentTest = index
            return  find(testForValue: self.testList[index])
        }
        set(newValue) {
            //print("oldValue:\(newValue)")
            guard let newValue = newValue, index < self.testList.count   else {   return   }
            guard self.testList.first(where: {  $0 == newValue.fileNumber   }) != nil else { return }
            if let posInResults = find(posForValue: self.testList[index]) {
                if self.results[posInResults].fileNumber == newValue.fileNumber {
                    self.currentTest = index
                    self.results[posInResults] = newValue
                }
                
            }
        }
    }
    func editRating(forIndex index: Int, completion:  (_ result: TestResult) -> TestResult       ) {
        guard  index < self.testList.count   else {   return   }
        guard let testPos = find(posForValue: self.testList[index]) else { return  }
        self.results[testPos] = completion(self.results[testPos])
    }
    func addRating(_ fileNumber: Int, lastAnswer answer: Bool) {
        if let position = find(posForValue: fileNumber) {
            let oldTest = self.results[position]
            self.results.remove(at: position)
            oldTest.lastAnswer = answer
            self.results.append(oldTest)
        }
        else {
            let testResult = TestResult(fileNumber, lastAnswer: answer)
            self.results.append(testResult)
        }
    }

//     ratins[2] = TestResult(4, lastAnswer: true)
//      let xx = ratins[2]
        
    func getCurrTest(numberOnList nr: Int) -> TestResult? {
        guard nr < self.testList.count  else {   return nil  }
        return  find(testForValue: self.testList[nr])
    }
    func setCurrTest() {

        
    }
    func xxxxxx() {
        for el in self.testList {
            print("el:\(el)")
            let bb = find(testForValue: el)
            print("bb:\(bb?.fileNumber ?? 0),\(bb?.lastAnswer ?? false)")
        }
    }
    func printf() {
        print("results:\(results)")
        print("testList:\(testList)")
        
        
    }
    func findElem(searchVal: Int) {
        if let val = self.results.first(where: {  $0.fileNumber == searchVal  }) {
            print("NEative:\(val)")
        }
    }
    func find(posForValue searchVal: Int)  -> Int? {
        for (index, value) in self.results.enumerated() {
            if value.fileNumber == searchVal {
                return index
            }
        }
        return nil
    }
    func find(testForValue searchVal: Int)  -> TestResult? {
        for (index, value) in self.results.enumerated() {
            if value.fileNumber == searchVal {
                return results[index]
            }
        }
        return nil
    }
    func saveRatings() {
        guard let uuId = database.selectedTestTable[0]?.uuId, self.results.count > 0 else {   return    }
        
        print("saveRatings, befor del:\(database.ratingsTable.count)")
        //database.ratingsTable[0]?.uuId_parent
        database.ratingsTable.deleteGroup(uuidDeleteField: "uuid_parent", forValue: uuId)
        database.ratingsTable.save()
        print("saveRatings,ratingsTable after del:\(database.ratingsTable.count)")
        
        print("saveRatings,results save:\(self.results.count)")
        for (index, value) in self.results.enumerated() {
            let rec = RatingsEntity(context: database.context)
            rec.lp = Int16(index)
            print("index:\(index).\(uuId)")
            rec.uuId = UUID()
            rec.uuid_parent = uuId
            rec.file_number = Int16(value.fileNumber)
            rec.good_answers = Int16(value.goodAnswers)
            rec.wrong_answers = Int16(value.wrongAnswers)
            rec.last_answer = value.lastAnswer
            rec.corrections_to_do = Int16(value.correctionsToDo)
            rec.repetitions_to_do = Int16(value.repetitionsToDo)
            _ = database.ratingsTable?.add(value: rec)
        }
        print("restoreRatings, befor save:\(database.ratingsTable.count)")
        database.ratingsTable?.save()
        print("restoreRatings, after save:\(database.ratingsTable.count)")
    }
    func saveTestList() {
        guard let uuId = database.selectedTestTable[0]?.uuId, self.testList.count > 0 else {   return     }

        print("saveTestList, befor save:\(self.testList.count)")
        database.testListTable.deleteGroup(uuidDeleteField: "uuid_parent", forValue: uuId)
        //database.testListTable.save()
        print("saveTestList, after save:\(self.testList.count)")
        
        for (index, value) in self.testList.enumerated() {
            let rec = TestListEntity(context: database.context)
            rec.lp = Int16(index)
            rec.uuId = UUID()
            rec.uuid_parent = uuId
            rec.rating_index = Int16(value)
            rec.done = true
            _ = database.testListTable?.add(value: rec)
        }
        database.testListTable?.save()
    }
    func restoreRatings() {
        var newRatings = [TestResult]()
        newRatings.removeAll()
        print("restoreRatings, restore:\(database.ratingsTable.count)")
        database.ratingsTable.forEach { index, oneElement in
            guard let elem = oneElement else {    return    }
            let fileNumber: Int = Int(oneElement?.file_number ?? 9999)
            let lastAnswer: Bool = oneElement?.last_answer ?? false
            let tmp = TestResult(fileNumber, lastAnswer: lastAnswer)
            
            tmp.correctionsToDo = Int(elem.corrections_to_do)
            tmp.repetitionsToDo = Int(elem.repetitions_to_do)
            tmp.setWrongAnswers(Int(elem.wrong_answers))
            tmp.setGoodAnswers(Int(elem.good_answers))
            tmp.errorMultiple = 2
            print("index:\(index)")
            newRatings.append(tmp)
        }
        if newRatings.count > 0 {
            self.results = newRatings
        }
        print("RRRRR:\(newRatings)")
    }
    struct TestListStruct
    {
        var lp: Int = 0
        var ratingIndex: Int = 0
        
    }
    func restoreTestList() {
        //    var testList: [Int] = [4,2,4,2,1,7]
        var newTestList = [TestListStruct]()
        newTestList.removeAll()
        print("restoreRatings, restore:\(database.ratingsTable.count)")
        database.testListTable.forEach { index, oneElement in
            guard let elem = oneElement else {    return    }
//            let lp: Int = Int(elem.lp)
//            let ratingIndex: Int = Int(elem.rating_index)
            let tmp = TestListStruct(lp: Int(elem.lp), ratingIndex: Int(elem.rating_index))
             
            //tmp.correctionsToDo = Int(elem.corrections_to_do)
            print("index:\(index)")
            //
            newTestList.append(tmp)
        }
        let aList = newTestList.sorted {    $0.lp < $1.lp  }.map {  $0.ratingIndex  }
        if aList.count > 0 {
            self.testList = aList
        }
        print("RRRRR:\(newTestList)")
    }
}

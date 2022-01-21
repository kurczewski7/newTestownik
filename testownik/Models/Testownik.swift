//
//  Testownik.swift
//  testownik
//
//  Created by Slawek Kurczewski on 26/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit
import  CoreData // to delete

protocol TestownikDelegate {
    func refreshButtonUI(forFilePosition filePosition: Testownik.FilePosition)
    func refreshTabbarUI(visableLevel: Int)
}
class Testownik: DataOperations {
    enum FilePosition {
        case first
        case last
        case other
    }
    struct Answer {
            let isOK: Bool
            let answerOption: String
    }
    var delegate: TestownikDelegate?
    var filePosition = FilePosition.first
    
    //override public var text: String? = "text"
    override var currentTest: Int  {
        didSet {
            print("currentTest:\(oldValue),\(currentTest)")
            delegate?.refreshButtonUI(forFilePosition: filePosition)
            // currentRow = currentTest < count ? currentTest : count-1
            if  self.currentTest == 0 {    filePosition = .first     }
            else if  self.currentTest == count-1 {   filePosition = .last     }
            else  {  filePosition = .other      }
        }
    }
        
//    var currentTest: Int = 0 {
//        didSet {
//            delegate?.refreshButtonUI(forFilePosition: filePosition)
//            currentRow = currentTest < count ? currentTest : count-1
//            if  currentTest == 0 {    filePosition = .first     }
//            else if  currentTest == count-1 {   filePosition = .last     }
//            else  {  filePosition = .other      }
//        }
//    }
    var visableLevel: Int = 4 {
        didSet {     delegate?.refreshTabbarUI(visableLevel: visableLevel)    }
    }
    // method depreciated ===> to deleted
    func fillData(totallQuestionsCount: Int) {
        var titles = [String]()
        var textLines = [String]()
        for i in 201...204 { //117
            titles = []
            let name = String(format: "%03d", i)
            print("name:\(name)")
            textLines=getText(fileName: name)
            if textLines[textLines.count-1].isEmpty {    textLines.remove(at: textLines.count-1) }
            for i in 2..<textLines.count {
                if !textLines[i].isEmpty  {    titles.append(textLines[i])      }
            }
            print("i:\(i), textLines: \(textLines)")
            let order = [99,5,7]
            let isOk = getAnswer(textLines[0])
            let answerOptions = fillOneTestAnswers(isOk: isOk, titles: titles)
            let sortedAnswerOptions = changeOrder(forAnswerOptions: answerOptions)
            let test = Test(code: textLines[0], ask: textLines[1], pict: nil, answerOptions: sortedAnswerOptions, order: order, youAnswers5: [], fileName: name)
            testList.append(test)
            print(test)
            print("\r\n")
        }
    }
    
    func fillDataDb() {
        var titles = [String]()
        var textLines = [String]()
        print("database.testDescriptionTable.count fillDataDb:\(database.testDescriptionTable.count)")
        database.testDescriptionTable.forEach { (index, testRecord) in
            if let txt = testRecord?.text, !txt.isEmpty {
                titles.removeAll()
                textLines = getTextDb(txt: txt)
                guard textLines.count > 2 else {    return     }
                for i in 2..<textLines.count {
                    if !textLines[i].isEmpty  {    titles.append(textLines[i])      }
                }
                // TODO: order
                let order = [99,5,7]
                let isOk = getAnswer(textLines[0])
                let answerOptions = fillOneTestAnswers(isOk: isOk, titles: titles)
                let sortedAnswerOptions = changeOrder(forAnswerOptions: answerOptions)
                let fileName = testRecord?.file_name?.components(separatedBy: ".")[0] ?? ""
                let test = Test(code: textLines[0], ask: textLines[1], pict: nil, answerOptions: sortedAnswerOptions, order: order, youAnswers5: [], fileName: fileName)
                self.testList.append(test)
            }
        }
     }
    
    func changeOrder(forAnswerOptions answerOptions: [Answer]) -> [Answer] {
        var position = 0
        var sortedAnswerOptions = [Answer]()
        var srcAnswerOptions = answerOptions
        for _ in 1...srcAnswerOptions.count {
            position = randomOrder(toMax: srcAnswerOptions.count-1)
            sortedAnswerOptions.append(srcAnswerOptions[position])
            srcAnswerOptions.remove(at: position)
        }
        return sortedAnswerOptions
        //let elem = srcAnswerOptions[position]
    }
    func randomOrder(toMax: Int) -> Int {
        return Int(arc4random_uniform(UInt32(toMax)))
    }
    func fillOneTestAnswers(isOk: [Bool], titles: [String]) -> [Answer] {
        var answerOptions: [Answer] = []
        let lenght = isOk.count < titles.count ? isOk.count : titles.count
        for i in 0..<lenght {
            answerOptions.append(Answer(isOK: isOk[i], answerOption: titles[i]))
        }
        return answerOptions
    }
    func isAnswerOk(selectedOptionForTest selectedOption: Int) -> Bool {
        var value = false
        if  selectedOption < testList[currentTest].answerOptions.count {
            value = testList[currentTest].answerOptions[selectedOption].isOK
        }
        return value
    }
    func findValue<T: Comparable>(currentList: [T], valueToFind: T) -> Int {
        var found = -1
        for i in 0..<currentList.count {
            if (currentList[i] == valueToFind)  {   found = i     }
        }
        return found
    }
    func getText(fileName: String, encodingSystem encoding: String.Encoding = .utf8) -> [String] {  //windowsCP1250
        var texts: [String] = ["brak danych"]
        var encodingType: String.Encoding = .isoLatin2
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let yy = "DDDD"
                let xxx = try String(contentsOfFile: path ,usedEncoding: &encodingType)
                print(("encoding:\(encodingType.rawValue)"))
                let data = try String(contentsOfFile: path ,encoding: encoding)
                let myStrings = data.components(separatedBy: .newlines)
                texts = myStrings
                print("text-Cs:\(texts)")
            }
            catch {
                print("ENCODE:\(encodingType)")
                print(error.localizedDescription)
            }
        }
        return texts
    }
    func checkCodePage(fileName: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
        let encodingList: [String.Encoding] = [String.Encoding.utf8, .windowsCP1250, .windowsCP1251, .windowsCP1252, .windowsCP1253, .windowsCP1254, .isoLatin2, .isoLatin1, .ascii, .unicode,.macOSRoman]
        var encodingType: String.Encoding = encoding
        var texts: [String] = ["brak danych"]
        var notFoundEncoding = true
        
        print("first encoding:\(encodingType.description),\(encodingType.rawValue)")
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                
                let str = try String(contentsOfFile: path ,usedEncoding: &encodingType)
                print(("encoding:\(encodingType.rawValue),\(encodingType.description)\nstr:\(str)\n"))
                
                let str1 = try String(contentsOfFile: path ,encoding: encodingType)
                let myStrings = str1.components(separatedBy: .newlines)
                texts = myStrings
                notFoundEncoding = false
                print("text-Cs:\(texts)")
            }
            catch {
                for i in 0..<encodingList.count {
                    if let str2 = giveCodepaeText(contentsOfFile: path, encoding: encodingList[i]) {
                        texts = str2.components(separatedBy: .newlines)
                        notFoundEncoding = false
                        break
                    }
                }
            }
            if notFoundEncoding {
                do {
                    let str3 = try String(contentsOfFile: path)
                    texts = str3.components(separatedBy: .newlines)
                }
                catch {
                    texts.removeAll()
                }
             }
        }
        else {
            texts.removeAll()
        }        
    return  texts
    }

            //            catch {
//                print("ENCODE:\(encodingType),\(encodingType.rawValue)")
//                print(error.localizedDescription)
//                do {
//
//                }
//                catch {
//                    do {
//                        let str2 = try String(contentsOfFile: path ,encoding: encodingList[3])
//                        let myStrings = str2.components(separatedBy: .newlines)
//                        texts = myStrings
//                        print("text-Cs druie:\(texts)")
//                    }
//                    catch {
//                        print("eeeerrrrrooorr")
//                    }
//                }
//            }
    func giveCodepaeText(contentsOfFile: String ,encoding: String.Encoding) -> String? {
        var retVal: String?
        let xxx = "/Users/slawek/Library/Developer/CoreSimulator/Devices/0ADA8F52-B81D-4FAD-A0D5-D1839A86029E/data/Containers/Bundle/Application/C734D989-BA8C-41C1-B29B-9E43179F4DB0/Testownik.app/newFile.txt"
        if contentsOfFile == xxx {
            do {
                let string = try String(contentsOfFile: contentsOfFile ,encoding: encoding)
                return string
            }
            catch {
                print("AAAABBB CCC")
            }
            
        }
        do {
            let str = try String(contentsOfFile: contentsOfFile ,encoding: encoding)
            print(("file:\(contentsOfFile),encoding:\(encoding.rawValue),\(encoding.description)\nstr:\(str)\n"))
            retVal = str
        }
        catch {
//            print(error.localizedDescription)
//            print("blad:\(contentsOfFile)")
            print("CCCC")
            retVal = nil
        }
        return retVal
    }
//        var encodingType: String.Encoding = .utf8
//        let file = "001.txt"
//        //var str = ""
//        let url = URL(fileURLWithPath: "http://www.wp.pl")
//
//        do {
////            let str1 = try String(contentsOf: url, usedEncoding: &encodingType)
////            print("Used for encoding url \(url.absoluteString) - \(str1): \(encodingType)")
//            print("file:\(fileName)")
//            let str2 = try String(contentsOfFile: fileName, usedEncoding: &encodingType)
//            print("Used for encoding string \(str2): \(encodingType)")
//        } catch {
//            print("XXXXXXX:AAAA")
//
//        }

//        do {
//        let xx = String(contentsOf: <#T##URL#>, usedEncoding: &T##String.Encoding)
//
//        }
        
//        do {
//            let str = try String(contentsOf: url, usedEncoding: &encodingType)
//            print("Used for encoding: \(encodingType)")
//        } catch {
//            do {
//                let str = try String(contentsOf: url, encoding: .utf8)
//                print("Used for encoding: UTF-8")
//            } catch {
//                do {
//                    let str = try String(contentsOf: url, encoding: .isoLatin1)
//                    print("Used for encoding: Windows Latin 1")
//                } catch {
//                    // Error handling
//                }
//            }
//        }


        
    func getTextDb(txt: String, encodingSystem encoding: String.Encoding = .utf8) -> [String]  {
        var texts: [String] = ["brak danych"]
        
//        let xxx = String.Encoding.windowsCP1250
        
        do {
            let data = try String(contentsOfFile: txt ,encoding: String.Encoding.windowsCP1252)
            let myStrings = data.components(separatedBy: .newlines)
            texts = myStrings
            print("texts:\(texts)")
        }
        catch {
            print(error.localizedDescription)
        }
        return texts
    }
    //        let xxx = "first\nsecond\nferd"
    //        let z = xxx.split(separator: "\n")
    //        let cc = xxx.data(using: String.Encoding.utf8)
    //        let dd = xxx.data(using: String.Encoding.windowsCP1250)
    //        var ff = Data(base64Encoded: xxx)
    //        print("ccc:\(String(describing: cc))")
    //        print("ccc:\(String(describing: dd))")
    //
    //        let ttt =  xxx.components(separatedBy: .newlines)
    //        print("ttt:\(ttt)")


    func getAnswer(_ codeAnswer: String) -> [Bool] {
        var answer = [Bool]()
        let myLenght=codeAnswer.count
        //print("myLenght:\(myLenght)")
        for i in 1..<myLenght {
            answer.append(codeAnswer.suffix(codeAnswer.count)[i]=="1" ? true : false)
        }
        //print("answer,\(answer)")
        return answer
    }
    func frstRandom(repeat: Bool) -> Test?   {
        return nil
    }
    func nextRandom(repeat: Bool) -> Test?  {
        return nil
    }
    func previousRandom(repeat: Bool) -> Test?  {
        return nil
    }
    func lastRandom(repeat: Bool) -> Test?  {
        return nil
    }    
    
    // MARK: Methods for Testownik database
    func loadTestFromDatabase() {
        database.selectedTestTable.loadData()
        //print("\nselectedTestTable.coun = \(database.selectedTestTable.count)")
        guard database.selectedTestTable.count > 0 else {   return     }
        if  let selectedUuid = database.selectedTestTable[0]?.toAllRelationship?.uuId {
            database.testDescriptionTable.loadData(forUuid: "uuid_parent", fieldValue: selectedUuid)
            if database.testDescriptionTable.count > 0 {
                print("file_name:\(String(describing: database.testDescriptionTable[0]?.file_name))")
                print("TEXT:\(String(describing: database.testDescriptionTable[0]?.text))")
                
                // TODO: clear data
                let txtVal = getTextDb(txt: database.testDescriptionTable[0]?.text ?? " ")
                if  txtVal.count < 3 {
                    print("Pusty rekord")
                    self.clearData()  }
                else    {
                    print("Pełny rekord")
                    fillDataDb()
                }
            }
        }
    }
}

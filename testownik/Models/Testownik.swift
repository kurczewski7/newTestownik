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
                //=========>
                textLines = getTextDb666(pathTxt: txt)
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
    func teeest() {
        loadStartedTest(forLanguage: .english_GB)
        loadStartedTest(forLanguage: .polish)
        
        loadStartedTest(forLanguage: .spanish)
        loadStartedTest(forLanguage: .french)
        loadStartedTest(forLanguage: .german)
    }
    func loadStartedTest(forLanguage lang: Setup.LanguaesList) {
        let prefLang = lang.rawValue.prefix(2).lowercased()
        for i in 801..<813 {
            let name = prefLang + String(format: "%03d", i)
            let txt = getText(fileName: "pl807.txt")
            let textLines = getText(fileName: name)
            //let path = Bundle.main.path(forResource: name, ofType: "txt")
            print("textLines:\(textLines)")
        }
    }
//=================================                     3###################       ========================
     func getText(fileName: String, encodingSystem encoding: String.Encoding = .utf8) -> [String] {  //windowsCP1250
        var texts: [String] = ["brak danych"]
        var encodingType: String.Encoding = .utf8
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
    func testOtherCodePageFile() {
        var texts: [String] = ["brak danych"]
        var xxx: String.Encoding = .iso2022JP
        
        print("\npoczatek A:\(xxx.rawValue),(xxx)")
        xxx = .windowsCP1250
        print("\npoczatek B:\(xxx.rawValue),(xxx)")
        
        for i in 1..<15 {
            xxx.rawValue = UInt(i)
            print("\n\(i):\(xxx.description)")
        }
        if let path = Bundle.main.path(forResource: "newFile", ofType: "txt") {
//            for i in 0..<20 {
//                xxx.rawValue = UInt(i)
//                if let str = giveCodepaeText(contentsOfFile: path, encoding: xxx) {
//                    texts = str.components(separatedBy: .newlines)
//                    print("text-Cs B:\(xxx.rawValue),\(texts)")
//                    //break
//                }
            }
        }
    
    func giveCodepaeText(contentsOfFile: String ,encoding: String.Encoding) -> String? {
        //var retVal: String?

        do {
            print("contentsOfFile:\(contentsOfFile)")
            print(("encoding:\(encoding.rawValue),file:\(contentsOfFile),\(encoding.description)"))
            let str = try String(contentsOfFile: contentsOfFile ,encoding: encoding)
            print(("\nstr:\(str)\n"))
            return str
        }
        catch {
//            print(error.localizedDescription)
//            print("blad:\(contentsOfFile)")
            print("KKKK:\(encoding.hashValue),\(encoding.description)")
              return nil
        }
    }
    //==========================
    func giveCodepaeText2(contentsOfFile: String ,encoding: String.Encoding) -> String? {
        return "brak"
    }

        
    func getTextDb666(pathTxt: String, encodingSystem encoding: String.Encoding = .utf8) -> [String]  {
        var texts: [String] = ["brak danych"]
        
//        let xxx = String.Encoding.windowsCP1250
        
        do {
            let data = try String(contentsOfFile: pathTxt ,encoding: encoding)
            let myStrings = data.components(separatedBy: .newlines)
            texts = myStrings
            print("texts:\(texts)")
        }
        catch {
            print(error.localizedDescription)
        }
        return texts
    }


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
                let txtVal = getTextDb666(pathTxt: database.testDescriptionTable[0]?.text ?? " ")
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




//    func getCodePageText(pathToFile path: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        return getCodePgTxt(path: path, encodingSystem: encoding)
//    }
//    func getCodePageText(fileName: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
//            return getCodePgTxt(path: path, encodingSystem: encoding)
//        }
//        else {
//            return  [String]()
//        }
//    }
//    private func getCodePgTxt(path: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        let encodingList: [String.Encoding] = [String.Encoding.utf8, .windowsCP1250, .windowsCP1251, .windowsCP1252, .windowsCP1253, .windowsCP1254, .isoLatin2, .isoLatin1, .ascii, .nonLossyASCII, .unicode, .macOSRoman, .utf16 ]
//        var encodingType: String.Encoding = encoding
//        var texts: [String] = ["brak danych"]
//
//        print("first encoding:\(encodingType.description),\(encodingType.rawValue)")
////        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
//        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//                if let codePage = checkCodePageId(path: path) {
//                    do {
//                        let str1 = try String(contentsOfFile: path ,encoding: codePage)
//                        let myStrings = str1.components(separatedBy: .newlines)
//                        texts = myStrings
//                        print("text-Cs A:\(codePage.description)")
//                        print("\n,\(texts)")
//                    }
//                    catch {
//                        for i in 0..<encodingList.count {
//                            if let str2 = giveCodepaeText(contentsOfFile: path, encoding: encodingList[i]) {
//                                texts = str2.components(separatedBy: .newlines)
//                                print("text-Cs B:\(encodingList[i].description)")
//                                print("\n,\(texts)")
//                                break
//                            }
//                        }
//                    }
//            }
//            else {
//                for i in 0..<encodingList.count {
//                    if let str2 = giveCodepaeText(contentsOfFile: path, encoding: encodingList[i]) {
//                        texts = str2.components(separatedBy: .newlines)
//                        print("text-Cs C:\(encodingList[i].description)")
//                        print("\n,\(texts)")
//                        break
//                    }
//                }
//            }
//        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
////        }
////        else {
////            print("removeAll")
////            texts.removeAll()
////        }
//    return  texts
//    }
//    func checkCodePageId(path: String )  -> String.Encoding? {
//        var encodingType: String.Encoding = .utf8
//
//        do {
//            let str = try String(contentsOfFile: path ,usedEncoding: &encodingType)
//            print(("encoding:\(encodingType.rawValue),\(encodingType.description)\nstr:\(str)\n"))
//
//            print("encoding Type:\(encodingType.description),\(encodingType.rawValue)")
//            return encodingType
//        }
//        catch {
//            return nil
//        }
//    }





//=================
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


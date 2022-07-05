//
//  AppDelegate.swift
//  Testownik
//
//  Created by Slawek Kurczewski on 14/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit
import CoreData
import CoreMedia


// FIXME: comment here
// TODO:  comment here
// MARK:  do zrobienia


let speech = Speech()

//let testownik99 = Testownik()
let testownik = Testownik()
let pictureLibrary = PictureLibrary()
let ratings = Ratings()


//let coreData = CoreDataStack()
//let database = Database(context: coreData.persistentContainer.viewContext)

@UIApplicationMain
   class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("S T A R T\n")

        var xxList: [Int] = [Int]()
        for i in 0..<320 {
            xxList.append(i+1)
        }
        let testToDo = TestToDo(rawTestList: xxList)
        
        if let x1 = testToDo[0] {
            print("X1:\(x1)")
        }
        if let x2 = testToDo[1,1] {
            print("x2:\(x2)")
        }
        let xx = testToDo.getElem(numberFrom0: 0)
        print("x=\(xx)\n==========")
        for i in 0..<180 {
            let yy = testToDo.getElem(numberFrom0: i)
            print("\(i):\(yy)")
            if i % 35 == 0 {
                print("-----")
            }
        }
        var kk = [Int]()    // [5,5,3,4,2,5]
        for _ in 0...5 {
            kk.append(Setup.randomOrder(toMax: 5))
        }
        kk = [2,2,2,1,3,3] //,4
        //kk = [5,5,3,4,2,5]
        //kk = [0,0,2,4,4,4]
        //kk = [2,1,6,5,3,4]
        //kk = [1,2,3,4,5,6]
        
        
        
        var spelInt = kk.map { NumberFormatter.localizedString(from: $0 as NSNumber, number: .spellOut) }
        var c = 0
        var row: [TestToDo.RawTest] = [TestToDo.RawTest]()
        for i in kk {
            let errCor = (c % 2 == 0  ? false : true)
            let y = TestToDo.RawTest(fileNumber: i, isExtraTest: true, checked: false, errorCorrect: errCor)
            row.append(y)
            c += 1
        }
        //print("\(row)")
        var tt = TestToDo.RawTest(fileNumber: 0, isExtraTest: true, checked: false, errorCorrect: true)
        
        
        let result = testToDo.isSortingOk(forRow: &row)
        //testToDo.reorganizeExtra(forRow: &row, fileNumber: 4,hawMenyTimes: 9000)
        print(("Sort result:\(result)"))
        //testToDo.addExtra(forRow: tt, fileNumber: 4, errorCorrect: true)
        //testToDo.addExtra(forRow: &row, fileNumber: 4, errorCorrect: true)
        
        //let yy = testToDo.getPositonsToDel(forRow: row, newRow: &row)
        testToDo.changeQueue(forRow: &row, fileNumber: 3)
        
        
        
//        for i in 0..< 10 {
//            
//        }
        
        //testToDo.reSorting(previousElem: tt, forRow: &row)
        
        //testToDo.mixTests(inputElements: &row)
        
        
        
        if let path0 = Bundle.main.path(forResource: "543", ofType: "txt") {
            let aa0 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: UInt(15)))
            print("aa0=\(aa0)")
            let aa1 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: UInt(4)))
            print("aa1=\(aa1)")
            var val: String.Encoding.RawValue = 0
            let aa3 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("aa3=\(aa3)")
            val = 1
            let bb = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("bb=\(bb)")
            val = 14
            let cc = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("cc=\(cc)")
        }
        ratings.xxxxxx()
        let rr = ratings[2]
        rr?.correctionsToDo = 1963
        
        print("rr:\(String(describing: rr))")
        ratings.printf()
        ratings[1] = rr
        ratings[2] = rr
        ratings.editRating(forIndex: 0) {
            $0.repetitionsToDo = 2021
            $0.lastAnswer = false
            $0.correctionsToDo = 1410
            return $0
        }
        ratings.editRating(forIndex: 3) { result in
            result.repetitionsToDo = 5555
            return result
        }

        ratings.editRating(forIndex: 11) { result in
            result.repetitionsToDo = 6666
            return result
        }
        
//        ratings.editRating(forIndex: 3) {
//            let nrFile = ratings
//        }
//        ratings.editRating(forIndex: 3) {
//            let tmp = self.
//            //tstResult.errorMultiple = 7
//            //return tstResult
//        }
      
        
        
        for i in 0..<Locale.preferredLanguages.count {
            print("System lang \(i):\(Locale.preferredLanguages[i])")
        }
        
        Locale.autoupdatingCurrent.languageCode
        print("App languae, Locale.autoupdatingCurrent.languageCode: \(Locale.autoupdatingCurrent.languageCode ?? "brak")")
        print("Settins dev, Locale.current:\(Locale.current.languageCode ?? "brak języka")")
        print("(Bundle.main.preferredLocalizations: \(String(describing: Bundle.main.preferredLocalizations.first))")
        print("Locale.current.identifier: \(Locale.current.identifier)")
       
        
//        extension Locale {
//            static var preferredLanguageCode: String {
//                let defaultLanguage = "en"
//                let preferredLanguage = preferredLanguages.first ?? defaultLanguage
//                return Locale(identifier: preferredLanguage).languageCode ?? defaultLanguage
//            }
//
//            static var preferredLanguageCodes: [String] {
//                return Locale.preferredLanguages.compactMap({Locale(identifier: $0).languageCode})
//            }
//        }
        

        speech.setLanguae(selectedLanguage: 3)
        speech.startSpeak()
        
        let fullHomePath = NSHomeDirectory()
        print("\n=========\nfullHomePath = file:///\(fullHomePath)")
        //database.allTestsTable.loadData(fieldName: "user_name", fieldValue: "trzeci")
        database.allTestsTable.loadData()
        database.selectedTestTable.loadData()
        database.testDescriptionTable.loadData()
        database.ratingsTable.loadData()
        database.testListTable.loadData()
        
        print("allTestsTable.count:\(database.allTestsTable.count)\n")
        print("selectedTestTable.count:\(database.selectedTestTable.count)\n")
        print("testDescriptionTable.count:\(database.testDescriptionTable.count)\n")
        print("Test name:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")
        
        
        print("rr2:\(ratings[2]?.fileNumber ?? 0),\(ratings[2]?.correctionsToDo ?? 0)")
        ratings.printf()
        ratings.saveRatings()
        ratings.saveTestList()
        ratings.restoreRatings()
        ratings.restoreTestList()

  
        let newVal = Settings.CodePageEnum.iso9
        let listen = Settings.shared.getValue(boolForKey: .listening_key)
        let _ = Settings.shared.getValue(boolForKey: .dark_thema_key)
        let _ = Settings.shared.getValue(boolForKey:  .listening_key)
        let _ = Settings.shared.getValue(stringForKey: .language_key)
        
        Settings.shared.setValue(forKey: .listening_key, newBoolValue:  !listen)
        Settings.shared.setValue(forKey: .code_page_key, newStringValue: newVal.rawValue)
        Settings.shared.setValue(forKey: .dark_thema_key, newBoolValue: true)
        Settings.shared.setValue(forKey: .repeating_key, newStringValue: Settings.RepeatingEnum.repeating_c.rawValue)
        
//        database.allTestsTable.deleteAll()
//        database.allTestsTable.save()
//        database.testDescriptionTable.deleteAll()
//        database.testDescriptionTable.save()
//        database.selectedTestTable.deleteAll()
//        database.selectedTestTable.save()
//        database.testListTable.deleteAll()
//        database.testListTable.save()
//        database.ratingsTable.deleteAll()
//        database.ratingsTable.save()
        
        if database.selectedTestTable.count == 0 {
            let selTest = SelectedTestEntity(context: database.context)
            selTest.uuId = UUID()
            _ = database.selectedTestTable.add(value: selTest)
            database.save()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }



}


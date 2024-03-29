//
//  ViewController.swift
//  Testownik
//
//  Created by Slawek Kurczewski on 14/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

protocol TestownikViewContDataSource {
    var listening: Listening { get }
    var command: Command { get }
    var gestures: Gestures { get }
}
class TestownikViewController: UIViewController, GesturesDelegate, TestownikDelegate, TestToDoDelegate, ListeningDelegate, TestownikViewContDataSource, CommandDelegate    {
//    func addAllRequiredGestures(sender: Gestures) {
//
//    }
    
    func addCustomGesture(_ gestureType: Gestures.GesteresList, forView aView: UIView?, _ touchNumber: Int) {
    }
        
    // MARK: other classes
    let listening = Listening()
    let command   = Command()
    var gestures  = Gestures()
    //var testownik = Testownik()

    //  MARK: variable
    var cornerRadius: CGFloat = 10
    let initalStackSpacing: CGFloat = 30.0
    struct ButtonParam {
        var Tag = 999
        var Color = UIColor.black
        var BackgroundColor = UIColor.yellow
    }
    var lastButton = ButtonParam()
    var tabHigh: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
"""
  
    let alphaLabel: CGFloat =  0.9
    var isLightStyle = true
    let selectedColor: UIColor   = #colorLiteral(red: 0.9999151826, green: 0.9882825017, blue: 0.4744609594, alpha: 1)
    let unSelectedColor: UIColor = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
    let okBorderedColor: UIColor = #colorLiteral(red: 0.2034551501, green: 0.7804297805, blue: 0.34896487, alpha: 1)
    let borderColor: UIColor     = #colorLiteral(red: 0.7254344821, green: 0.6902328134, blue: 0.5528755784, alpha: 1)
    let otherColor: UIColor      = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
    
    //  MARK: IBOutlets
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var askPicture: UIImageView!
    
    @IBOutlet weak var listeningText: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var actionsButtonStackView: UIStackView!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    @IBOutlet weak var microphoneButt: UIBarButtonItem!
    
    @IBOutlet weak var highButton1: NSLayoutConstraint!
    @IBOutlet weak var highButton2: NSLayoutConstraint!
    @IBOutlet weak var highButton3: NSLayoutConstraint!
    @IBOutlet weak var highButton4: NSLayoutConstraint!
    @IBOutlet weak var highButton5: NSLayoutConstraint!
    @IBOutlet weak var highButton6: NSLayoutConstraint!
    @IBOutlet weak var highButton7: NSLayoutConstraint!
    @IBOutlet weak var highButton8: NSLayoutConstraint!
    @IBOutlet weak var highButton9: NSLayoutConstraint!
    @IBOutlet weak var highButton10: NSLayoutConstraint!
    
    var pictureSwitchOn: Bool = false {
        didSet {
            if self.pictureSwitchOn == true {
                askLabel.isHidden = true
                askPicture.isHidden = false
            }
            else {
                askLabel.isHidden = false
                askPicture.isHidden = true
            }
        }
    }
    @IBAction func microphonePress(_ sender: UIBarButtonItem) {
        microphoneButt.image = (microphoneButt.image == UIImage(systemName: "mic") ? UIImage(systemName: "mic.fill") : UIImage(systemName: "mic"))
    }
    @IBAction func nevButtonSpaceSubPress(_ sender: UIBarButtonItem) {
        stackView.spacing -= 5
    }
    @IBAction func ResizeButtonPlusPress(_ sender: UIBarButtonItem) {
        for buttHight in tabHigh {  buttHight.constant += 2        }
    }
    @IBAction func ResizeButtonMinusPress(_ sender: UIBarButtonItem) {
         askLabel.layer.cornerRadius = 10
        for buttHight in tabHigh {       buttHight.constant -= 2        }
    }
    @IBAction func firstButtonPress(_ sender: UIButton) {
        testownik.first()
    }
    @IBAction func nextButtonPress(_ sender: UIButton) {
        if testownik.filePosition != .last {      testownik.next()        }
    }
    @IBAction func previousButtonPress(_ sender: UIButton) {
        if testownik.filePosition != .first  {       testownik.previous()  }
    }
    @IBAction func checkButtonPress(_ sender: UIButton) {
        guard let currTest = testownik[testownik.currentTest] else {    return        }
        let countTest = currTest.answerOptions.count        //okAnswers.count
        for i in 0..<countTest {
            if let button = stackView.arrangedSubviews[i] as? UIButton {
                button.layer.borderWidth =  currTest.answerOptions[i].isOK ? 3 : 1
                button.layer.borderColor = currTest.answerOptions[i].isOK ? UIColor.systemGreen.cgColor : UIColor.brown.cgColor
            }
        }
    }

    func dddddd() {
         let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let label = UILabel(frame: frame)
        let button = UIButton(frame: frame)
        button.contentHorizontalAlignment = .center
        let image = UIImage(named: "001.png")
        let uiImageView = UIImageView()
        uiImageView.image = image
        uiImageView.alignmentRect(forFrame: frame)
        
        button.setImage(image, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundImage(for: .normal)
    }
    
    // MARK: TestToDoDelegate
    func allTestDone() {
        print("allTestDone")
    }
    func progress(forCurrentPosition currentPosition: Int, totalCount count:Int) {
        guard count > 0 else { return }
        let promil = Int((currentPosition * 1000)/count)
        print("progress:\(promil)")
    }
//    func refreshFilePosition(newFilePosition filePosition: TestToDo.FilePosition) {
//        print("refreshFilePosition: \(filePosition)")
//    }

    // MARK: addAllRequiredestures
    func addAllRequiredGestures(sender: Gestures) {
        guard  gestures.view != nil  else { return   }
        sender.addSwipeGestureToView(direction: .right)
        sender.addSwipeGestureToView(direction: .left)
        sender.addSwipeGestureToView(direction: .up)
        sender.addSwipeGestureToView(direction: .down)
        sender.addPinchGestureToView()
        sender.addScreenEdgeGesture()
        sender.addTapGestureToView()
        //gestures.addLongPressGesture()
        //gestures.addForcePressGesture()
    }
    //Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(startMe), userInfo: nil, repeats: false)
    // MARK: GesturesDelegate  protocol metods
    func tapRefreshUI(sender: UITapGestureRecognizer) {
        if Setup.animationEnded {
            gestures.disabledOtherGestures = false
        }
        if let nr = sender.view?.tag {
            if nr == 2021 {
                sender.view?.window?.rootViewController?.dismiss(animated: true, completion: {
                    Setup.animationEnded = true
                    self.gestures.disabledOtherGestures = false
                    sender.view?.removeFromSuperview()
                    print("TO JUZ JEST  KONIEC")
                    //print("NR 0:\(self.lastButton.Tag)")
                    if  (0...9).contains(self.lastButton.Tag) {
                        if let oldButton = self.stackView.arrangedSubviews[self.lastButton.Tag] as? UIButton {
                            
//                            UIView.animate(withDuration: 2.5, delay: 0.3, options: []) {
//                                oldButton.tintColor = self.lastButton.Color
//                            }, completion: nil)
                            Setup.popUpStrong.frame = sender.view?.frame
                            UIView.animate(withDuration: 2.0, delay: 0.2, options: []) {
                                oldButton.tintColor = self.lastButton.Color
                                oldButton.backgroundColor = self.lastButton.BackgroundColor
                            }
                        }
                        print("NR 1:\(self.lastButton.Tag)")
                    }
                    //Setup.setTextColor(forToastType: .toast, backgroundColor: UIColor.brown)
                })
           }
            if (0...9).contains(nr) {
                if let button = sender.view as? UIButton {
                    // let txtLabel = button.titleLabel?.text
//                    self.lastButton.Tag = nr
//                    self.lastButton.Color = button.tintColor
                    //let currTest = testownik[testownik.currentTest]
                    //button.tintColor = UIColor.purple
                    button.layer.borderWidth = button.layer.borderWidth == 1 ? 3 : 1
                    //currTest.answerOptions[nr].isOK ? 3 : 1
                    button.layer.borderColor = button.layer.borderColor == UIColor.brown.cgColor ? UIColor.systemYellow.cgColor : UIColor.brown.cgColor
                    //currTest.answerOptions[nr].isOK ? UIColor.systemGreen.cgColor : UIColor.brown.cgColor
                }
            }
            print("tapRefreshUI NOWY zz:\(sender.view?.tag ?? 0)")
        }
    }
    func pinchRefreshUI(sender: UIPinchGestureRecognizer) {
        print("Pinch touches:\(sender.numberOfTouches),\(sender.scale) ")
        stackView.spacing = initalStackSpacing * sender.scale
        //view.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    func eadgePanRefreshUI() {
        print("Edge gesture")
//        let xx = UILabel()
//        let yy = xx.intrinsicContentSize.width
    }
    //======================
    func longPressRefreshUI(sender: UILongPressGestureRecognizer) {
        if let nr = sender.view?.tag {
            if (0...9).contains(nr) {
                    self.lastButton.Tag = nr
                    print("Tag:\(nr)")
                    if let button = sender.view as? UIButton, let txtLabel = button.titleLabel?.text {
                        print("BUTTON \(nr):\(txtLabel)")
                        self.lastButton.Color = button.tintColor
                        self.lastButton.BackgroundColor = button.backgroundColor ?? .orange
                        button.tintColor = UIColor.purple
                        button.backgroundColor = .yellow
                        gestures.disabledOtherGestures = true
                        Setup.popUpBlink(context: self, msg: txtLabel, numberLines: 5, height: 150) {
                            button.tintColor = self.lastButton.Color
                            button.backgroundColor = self.lastButton.BackgroundColor
                            self.gestures.disabledOtherGestures = false
                        }
                        //button.backgroundColor = .magenta
                    }
                }
                if nr == 2021 {
                     print("TAG:\(nr)")
                 }
            //buttons[nr].titleLabel?.scrollLeft()
        }
        print("longPressRefreshUI End:\(sender.view?.tag ?? 0),")
    }
    //==================
    func forcePressRefreshUI(sender: ForcePressGestureRecognizer) {
        if let nr = sender.view?.tag {
            if (0...9).contains(nr) {
                print("Tag:\(nr)")
                gestures.disabledOtherGestures = true
                if let button = sender.view as? UIButton, let txtLabel = button.titleLabel?.text {
                    print("Label:\(txtLabel)")
                    self.lastButton.Tag = nr
                    self.lastButton.Color = button.tintColor
                    self.lastButton.BackgroundColor = button.backgroundColor ?? .orange
                    button.tintColor = .purple
                    button.backgroundColor = .yellow
                    
                    let label = Setup.popUpStrong(context: self, msg: txtLabel, numberLines: 5, height: 150)
                    label.frame = Setup.popUpStrong.frame!
                    //Setup.popUpStrong.frame = label.frame
                    gestures.addTapGestureToView(forView: label, touchNumber: 1)
                    gestures.addSwipeGestureToView(direction: .down, forView: label)
                    gestures.addSwipeGestureToView(direction: .up, forView: label)
                    //label.gestureRecognizers?.removeAll()
                }
            }
            print("forcePressRefreshUI,\(sender.numberOfTouches),\(sender.view?.tag ?? 0)")
        }
    }
    func swipeRefreshLabel(sender: UISwipeGestureRecognizer, directions: [UISwipeGestureRecognizer.Direction]) {        
        if let tag = sender.view?.tag, tag == 2021 {
            if directions.count == 2 && (directions[0] == .down || directions[0] == .up ){
                var frame = sender.view?.frame
                if sender.direction == .up {
                    print("MOVE UP:\(sender.location(in: sender.view).y)")
                    frame?.origin.y -= sender.location(in: sender.view).y
                }
                else if sender.direction == .down {
                    print("MOVE DOWN:\(sender.location(in: sender.view).y)")
                    frame?.origin.y += sender.location(in: sender.view).y
                }
                UIView.animate(withDuration: 0.15) {
                    sender.view?.frame = frame!
                }
                //Setup.popUpStrong.frame = frame!
            }
            print("swipeRefreshLabel:\(tag),\(sender.direction.rawValue)")            
        }
    }
    func swipeRefreshUI(direction: UISwipeGestureRecognizer.Direction) {
        print("=====\nA currentTest: \(testownik.currentTest)")
        //if let tag =
        switch direction {
            case .right:
                //if testownik.count > 1 {
                    testownik.previous()
                    //testownik.currentTest -=  testownik.filePosition != .first  ? 1 : 0
                //}
                print("Swipe to right")
            case .left:
                //if testownik.count > 0 {
                    testownik.next()
                    //testownik.currentTest +=  testownik.filePosition != .last  ? 1 : 0
                //}
                print("Swipe  & left ")
            case .up:
                print("Swipe up")
                testownik.visableLevel +=  testownik.visableLevel < 4 ? 1 : 0
            case .down:
                print("Swipe down")
                testownik.visableLevel -= testownik.visableLevel > 0 ? 1 : 0
            default:
                print("Swipe unrecognized")
            }
         print("Y pos: \(testownik.currentTest)")
    }
    
    // MARK: TestownikDelegate protocol "refreshUI" metods
    func refreshContent(forFileNumber fileNumber: Int) {
        let test = testownik[fileNumber]
        
    }
//    func refreshContent(forCurrentTest test: Test) {
//        if let fileNumber = testownik.testToDo?.getCurrent()?.fileNumber {
//            if fileNumber < testownik.count {
//                testownik.currentTest = fileNumber
//                refreshView()
//            }
//        }
//
//        // MARK: To do
//    }
    func refreshButtonUI(forFilePosition filePosition: TestToDo.FilePosition) {
        print("filePosition=\(filePosition)")
        if filePosition == .first {
            hideButton(forButtonNumber: 0)
            hideButton(forButtonNumber: 1)
        }
        else if filePosition == .last {
            hideButton(forButtonNumber: 3)
        }
        else {
            hideButton(forButtonNumber: 0, isHide: false)
            hideButton(forButtonNumber: 1, isHide: false)
            hideButton(forButtonNumber: 3, isHide: false)
        }
        refreshView()
    }

    // MARK: ListeningDelegate method
    func updateGUI(messae recordedMessage: String) {
        listeningText.text = recordedMessage
    }
    func listenigStartStop(statusOn: Bool) {
        microphoneButt.image = (statusOn ?  UIImage(systemName: "mic.fill") : UIImage(systemName: "mic") )
    }
    @objc func startMe() {
        //listening.didTapRecordButton()
        listeningText.text = "🔴  Start listening  🎤 👄"
        //listeningText.text =
        

        //let yy = command.findCommand(forText: text)
        //findText(forText: text, patern: "lewo")
    }
    func tapNumberButton(forCommand cmd: Command.CommandList) {
        if Setup.animationEnded {
            gestures.disabledOtherGestures = false
            let butt = UIButton()
            butt.tag = cmd.rawValue
            buttonAnswerPress(sender: UIButton())
            print("TAG:\(butt.tag)")
        }
        else {
           print("Gestures disabled")
        }
    }
    func executeCommand(forCommand cmd: Command.CommandList) {
        print("COMMAND executeCommand:\(cmd.rawValue):\(command.vocabularyEn[cmd.rawValue][0])")
        print("stackView.arrangedSubviews.coun:\(stackView.arrangedSubviews.count)")
    
        print("One:\(String(describing: (stackView.arrangedSubviews[0] as! UIButton).titleLabel?.text))")
        switch cmd {
            case .start:        firstButtonPress(UIButton())
            case .previous:     previousButtonPress(UIButton())
            case .check:        checkButtonPress(UIButton())
            case .next:         nextButtonPress(UIButton())
            case .reduceScr:    testownik.visableLevel +=  (testownik.visableLevel < 4 ? 1 : 0)
            case .incScreen:    testownik.visableLevel -= (testownik.visableLevel > 0 ? 1 : 0)
            case .left:         firstButtonPress(UIButton())
            case .righi:        print("CMD")
            case .fullScreen:   print("CMD")
            case  .one,
                  .two,
                  .three,
                  .four,
                  .five,
                  .six,
                  .seven,
                  .eight,
                  .nine,
                  .ten: tapNumberButton(forCommand: cmd)
                        let butt = UIButton()
                        butt.tag = cmd.rawValue
                        buttonAnswerPress(sender: UIButton())
            case .end:          print("CMD")
            case .exit:         print("CMD")
            case .listen:       print("CMD")
            case .readOn:       print("CMD")
            case .showResult:   print("CMD")
            case .empty:        print("CMD")
        }
//        for curButt in stackView.arrangedSubviews     {
//            if let butt = curButt as? UIButton {
//                butt.isHidden =  false
//                butt.setTitle("\(Setup.placeHolderButtons) \(i)", for: .normal)
//                i += 1
//            }
//        }
    }
    // MARK: IBAction
    @IBAction func navButtSpaseAddPress(_ sender: UIBarButtonItem) {
        stackView.spacing += 5
//        stackView.
//        UIView.animateWithDuration(0.25) { () -> Void in
//            newView.hidden = false
//            scroll.contentOffset = offset
//        }
    }
    @objc func tapAction(sender :UITapGestureRecognizer) {
        print("TAP AAAAAAAA")
        sender.view?.removeFromSuperview()
        //self.view.removeFromSuperview(sender.view)
        //sender.view?.window?.rootViewController?.dismiss(animated: true, completion: {
            print("KONIEC")
    }
        //window?.rootViewController?.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    //}
    // MARK: viewDidLoad - initial method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //testownik.first()
        
        print("TestownikViewController viewDidLoad-testownik.count:\(testownik.count)")        
        Settings.shared.saveTestPreferences()
        
        self.view?.tag = 111
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        gesture.numberOfTouchesRequired = 1
        askLabel.isUserInteractionEnabled = true
        askLabel.addGestureRecognizer(gesture)
        Settings.shared.checkResetRequest(forUIViewController: self)
        
        
        listening.linkSpeaking = speech.self
        listening.delegate     = self
        command.delegate       = self
        //testownik.delegate     = self
        gestures.delegate      = self        
        testownik.testToDo?.delegate = self
        
        gestures.setView(forView: view)
        
        listeningText.text = loremIpsum
        listeningText.userAnimation(12.8, type: .push, subType: .fromLeft, timing: .defaultTiming)
        //listeningText.alpha = alphaLabel
        listening.requestAuth()
        print("Test name 2:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")
        
        var i = 0
        self.title = "Test (001)"
        // MARKT: MAYBY ERROR
        //testownik.loadTestFromDatabase()
        print("Stack count: \(actionsButtonStackView.arrangedSubviews.count)")
        stackView.arrangedSubviews.forEach { (button) in
            if let butt = button as? UIButton {
                butt.backgroundColor = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
                butt.layer.cornerRadius = self.cornerRadius
                butt.layer.borderWidth = 1
                butt.layer.borderColor = UIColor.brown.cgColor
                //butt.addTarget(self, action: #selector(buttonAnswerPress), for: .touchUpInside) //touchUpInside
                gestures.addTapGestureToView(forView: butt)
                gestures.addForcePressGesture(forView: butt)
                gestures.addLongPressGesture(forView: butt)
                 butt.tag = i
                i += 1
            }
        }
        
        tabHigh.append(highButton1)
        tabHigh.append(highButton2)
        tabHigh.append(highButton3)
        tabHigh.append(highButton4)
        tabHigh.append(highButton5)
        tabHigh.append(highButton6)
        tabHigh.append(highButton7)
        tabHigh.append(highButton8)
        tabHigh.append(highButton9)
        tabHigh.append(highButton10)
        
        addAllRequiredGestures(sender: gestures)        
        askLabel.layer.cornerRadius = self.cornerRadius
        
        // TODO: POPRAW
        testownik.createStartedTest()
        testownik.refreshData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear viewWillAppear")
        Settings.shared.readCurrentLanguae()
        
        print("Test name 3:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")       
//       if database.testToUpgrade {
//            testownik.loadTestFromDatabase()
//       }
        if testownik.isChanged {
            //testownik.refreshData()
            clearView()
        }
        refreshView()
        self.view.setNeedsUpdateConstraints()
        super.viewWillAppear(animated)
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(startMe), userInfo: nil, repeats: false)
    }
    //--------------------------------
    // TODO: Check content
    func resizeView() {
        //self.view.setNeedsUpdateConstraints()
        //self.view.layoutIfNeeded()
        //viewWillAppear(true)
        //self.view.setNeedsDisplay()
        //delegateView.setNeedsDisplay()
        //delegateView.layoutIfNeeded()
        //delegate.setNeedsUpdateConstraints()
    }
    @objc func restart() {
        listeningText.alpha = alphaLabel
    }
    func refreshTabbarUI(visableLevel: Int) {
        print("visableLevel: \(visableLevel)")
        switch visableLevel
            {
            case 4:
                listeningText.isHidden = false
                self.listeningText.alpha = alphaLabel
                buttonNaviHide(isHide: false)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = false
                resizeView()
                // setNeedsUpdateConstraints
            case 3:
                self.listeningText.alpha = alphaLabel
                listeningText.isHidden = false
                buttonNaviHide(isHide: false)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = true
                resizeView()
                //viewWillAppear(true)
                //viewDidLoad()
            case 2:
                self.listeningText.alpha = alphaLabel
                listeningText.isHidden = false
                buttonNaviHide(isHide: true)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = true
                resizeView()
            case 1:
                listeningText.isHidden = false
                //listeningText.layer.animation(forKey: <#T##String#>)
                
                UIView.animate(withDuration: 10.0, delay: 0.2,
                    options: .curveEaseOut, animations: {
                    self.listeningText.alpha = 0.0
                    }, completion: {(isCompleted) in   print("Animation finished")})
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(restart), userInfo: nil, repeats: true)
                
                //listeningText.layer.removeAllAnimations()
                //self.listeningText.alpha = 1.0
                
                buttonNaviHide(isHide: true)
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.isNavigationBarHidden = true
            case 0:
                listeningText.isHidden = true
                self.listeningText.alpha = alphaLabel
                let xx = UILabel()
                xx.font = UIFont(name: "Helvetica Neue", size: 20)
                xx.textColor = .red
                xx.tintColor = .blue
            default: print("ERROR")
        }
    }
    // MARK: Shake event method
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            tabBarController?.overrideUserInterfaceStyle = isLightStyle ? .dark : .light
            isLightStyle.toggle()
            print("Shake")
        }
    }
    func buttonNaviHide(isHide: Bool) {
        for elem in actionsButtonStackView.arrangedSubviews {
            //elem.layer.zPosition = isHide ? -1 : 0
            elem.isHidden = isHide
        }
    }
    func resizeView(toMaximalize: Bool? = nil) {
        if let toAddSize = toMaximalize {
            stackView.spacing += toAddSize ? 1 : -1
        }
    }
    // MARK: Method to press answer button
    @objc func buttonAnswerPress(sender: UIButton) {
        let bgColorSelelect:   UIColor =  selectedColor
        let bgColorUnSelelect: UIColor =  unSelectedColor
        let youSelectedNumber: Int = sender.tag
        var isChecked:Bool = false
        
        print("buttonAnswerPress:\(youSelectedNumber)")
        guard testownik.currentTest < testownik.count else {  return   }
        isChecked = testownik[testownik.currentTest]?.youAnswer2.contains(youSelectedNumber) ?? false
        if isChecked {
            testownik[testownik.currentTest]?.youAnswer2.remove(youSelectedNumber)
            isChecked = false
        } else  {
            testownik[testownik.currentTest]?.youAnswer2.insert(youSelectedNumber)
            isChecked = true
        }
        //#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        //#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        
        if let button = stackView.arrangedSubviews[youSelectedNumber] as? UIButton {
            button.layer.borderWidth = 3
            //button.layer.borderColor = okAnswer ? UIColor.green.cgColor : UIColor.red.cgColor
            button.layer.backgroundColor = isChecked ?  bgColorSelelect.cgColor : bgColorUnSelelect.cgColor
        }
        //--------------------
//        var found = false
//
//        let okAnswer = isAnswerOk(selectedOptionForTest: youSelectedNumber)
//
//        for elem in testownik[testownik.currentTest].youAnswers {
//            if elem == testownik.currentTest {   found = true     }
//        }
//        if !found {
//            testownik[testownik.currentTest].youAnswers.append(youSelectedNumber)
//        }
//        if let button = stackView.arrangedSubviews[youSelectedNumber] as? UIButton {
//            button.layer.borderWidth = 3
//            button.layer.borderColor = okAnswer ? UIColor.green.cgColor : UIColor.red.cgColor
//        }
        print("aswers:\(testownik[testownik.currentTest]?.youAnswers5)")
        print("aswers2:\(testownik[testownik.currentTest]?.youAnswer2.sorted())")
    }
    func isAnswerOk(selectedOptionForTest selectedOption: Int) -> Bool {
         var value = false
        if  selectedOption < testownik[testownik.currentTest]?.answerOptions.count ?? 0 {
            value = testownik[testownik.currentTest]?.answerOptions[selectedOption].isOK ?? false
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
    func hideButton(forButtonNumber buttonNumber: Int, isHide: Bool = true) {
        if let button = actionsButtonStackView.arrangedSubviews[buttonNumber] as? UIButton {
            button.isHidden = isHide
        }
    }
    func clearView() {
        var i = 1
        //let totalQuest = 7
        askLabel.text = "\(Setup.placeHolderTitle)"
        for curButt in stackView.arrangedSubviews     {
            if let butt = curButt as? UIButton {
                butt.isHidden =  false
                butt.setTitle("\(Setup.placeHolderButtons) \(i)", for: .normal)
                i += 1
            }
        }
    }
    func refreshView() {
        var i = 0
        let image = UIImage(named: "002.png")
        let set = Set([6,8,9])
        guard testownik.currentTest < testownik.count else {
            print("JEST \(testownik.count)  TESTOW")
            return            
        }
        guard let txtFile = testownik[testownik.currentTest]?.fileName, testownik.currentTest < testownik.count else {   return   }
        self.title = "Test \(txtFile)"
        // TODO: check it
        testownik[testownik.currentTest]!.youAnswer2 = []
        let totalQuest = testownik[testownik.currentTest]!.answerOptions.count
        testownik[testownik.currentTest]!.youAnswers5 = []
        askLabel.text = testownik[testownik.currentTest]!.ask
        //askPicture.image = testownik[testownik.currentTest].pict
        //testownik[testownik.currentTest].pict = UIImage(named: "004.png")
        if  let currPict = testownik[testownik.currentTest]!.pict {
            askPicture.image = currPict
            pictureSwitchOn = true
        }
        else {
            pictureSwitchOn = false
        }        
        for curButt in stackView.arrangedSubviews     {
            if let butt = curButt as? UIButton {
                butt.contentHorizontalAlignment =  (Setup.isNumericQuestions ? .left : .center)
                butt.isHidden = (i < totalQuest) ? false : true
                guard testownik.isCurrentValid else {   return     }
                butt.setTitle((i < totalQuest) ? Setup.getNumericPict(number: i) + testownik[testownik.currentTest]!.answerOptions[i].answerOption : "", for: .normal)
                butt.layer.borderWidth = 1
                butt.layer.borderColor = UIColor.brown.cgColor
                let isSelect = testownik[testownik.currentTest]?.youAnswer2.contains(i) ?? false
                butt.layer.backgroundColor = isSelect ? selectedColor.cgColor: unSelectedColor.cgColor
                // MARK: ggggg ffffff
                if set.contains(i)  {
                    butt.setTitle(" \(i+1)", for: .normal)
                    butt.setImage(image, for: .normal)
                    butt.contentHorizontalAlignment = Setup.currentAligmentButton
                    //butt.alpha = 0.60
                    //butt.backgroundColor?.withAlphaComponent(0.1)
                }
            }
            i += 1
        }
        actionsButtonStackView.arrangedSubviews[0].isHidden = (testownik.filePosition == .first)
        actionsButtonStackView.arrangedSubviews[1].isHidden = (testownik.filePosition == .first)
    }
    func getText(fileName: String, encodingSystem encoding: String.Encoding = .utf8) -> [String] {  //windowsCP1250
        var texts: [String] = ["brak"]
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
//                let charSetFileType = NSHFSTypeOfFile(path)
//                print("File char set: \(charSetFileType)")
                //let xx = String("ąćśżź")
                //xx.encode(to: <#T##Encoder#>)
                //stringWithContentsOfFile;: aaa, usedEncoding:error: )
                let data = try String(contentsOfFile: path ,encoding: encoding)
                let myStrings = data.components(separatedBy: .newlines)
                texts = myStrings
            }
            catch {
                print(error)
            }
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listening.stopRecording()
        speech.stopSpeak()
    }
    
        //    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        //    button.backgroundColor = .greenColor()
        //    button.setTitle("Test Button", forState: .Normal)
        //    button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        //
}


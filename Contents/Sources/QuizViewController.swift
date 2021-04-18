//
//  QuizViewController.swift
//  Book_Sources
//
//  Created by Prajwal Kulkarni on 11/04/21.
//

import UIKit
import AVFoundation
import SwiftUI
import PlaygroundSupport


@available(iOS 13.0, *)
public class QuizViewController: UIViewController{
    
    
    //MARK: - Variables and constants
    
    //Get screen dimens
    lazy var width = self.view.bounds.width
    lazy var height = self.view.bounds.height
    
    
    //Declare UIButtons and UILabels
    private var optn1,optn2,optn3,optn4,lifeline: UIButton?
    private var playAgainButton: UIButton?
    private var questionLabel:UILabel?
    private var stakeLabel:UILabel?
    private var winningLabel:UILabel?
    
    
    private let offset:CGFloat = 10
    
    private var lifelineUsed: Bool = false
    
    //Initialize audio instance
    private var audioPlayer = AVAudioPlayer()
    
    //QuizLogic Handler instance
    var logicHandler = QuizLogicHandler()
    var question = [Question]()
    
    private var cell: CAEmitterCell?
    private var emitter: CAEmitterLayer?
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background Image to occupy the the complete frame
        self.view.addBackground()
        
        //Setup buttons and labels
        setupViews()
        
        //Dislpay question and options
        updateQuestionAndOptions()
        
    }
    
    //MARK: - UI
    func setupViews(){
        
        
        //Setup UI.
        
        //Static dimens for buttons.
        let btnHeight: CGFloat = 50
        let btnWidth: CGFloat = (width/2) - 2*offset
        
        
        
        //Using NSLayoutConstraint to anchor the views relative to the frame and subviews.
        let logo = UIImage(imageLiteralResourceName: "WWTBACW")
        let logoImage = UIImageView(image: logo)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.contentMode = .scaleAspectFit
        self.view.addSubview(logoImage)
        NSLayoutConstraint.activate([logoImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
                                     logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),logoImage.widthAnchor.constraint(equalToConstant: 200),logoImage.heightAnchor.constraint(equalToConstant: 200)
                                     ])
        
        questionLabel = PaddingLabel()
        questionLabel!.textAlignment = .center
        questionLabel!.layer.masksToBounds = true
        questionLabel!.text = logicHandler.question[logicHandler.questionNumber].question
        questionLabel!.translatesAutoresizingMaskIntoConstraints = false
        questionLabel!.textColor = .white
        questionLabel!.backgroundColor = UIColor.black
        questionLabel!.layer.borderWidth = 2
        questionLabel!.layer.borderColor = UIColor.white.cgColor
        questionLabel!.layer.cornerRadius = 40
        questionLabel!.layer.zPosition = 1
        questionLabel!.numberOfLines = 3
        
        
        self.view.addSubview(questionLabel!)
        
        NSLayoutConstraint.activate([questionLabel!.topAnchor.constraint(equalTo: logoImage.bottomAnchor,constant: 50),questionLabel!.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),questionLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),questionLabel!.widthAnchor.constraint(equalToConstant: (2*btnWidth) + 20 ),questionLabel!.heightAnchor.constraint(equalToConstant: 100)])
        
        //questionLabel?.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20)
        
        //horizontal white line behind question label.
        let line = UIView()
        line.backgroundColor = .white
        line.layer.zPosition = 0
        line.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(line)
        NSLayoutConstraint.activate([line.centerYAnchor.constraint(equalTo: logoImage.bottomAnchor,constant: 100),line.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),line.widthAnchor.constraint(equalToConstant: (3*btnWidth) + 20 ),line.heightAnchor.constraint(equalToConstant: 3)])
        
        
        optn1 = UIButton()
        optn1?.translatesAutoresizingMaskIntoConstraints = false
        optn1!.backgroundColor = .black
        optn1!.layer.borderWidth = 2
        optn1!.layer.zPosition = 1
        optn1!.layer.cornerRadius = 20
        optn1!.layer.borderColor = UIColor.white.cgColor
        optn1!.tag = 1
        optn1!.setTitle(logicHandler.getOption(optionNumber: 0), for: .normal)
        
        optn1!.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        self.view.addSubview(optn1!)
        NSLayoutConstraint.activate([optn1!.topAnchor.constraint(equalTo: view.centerYAnchor,constant: 40),optn1!.rightAnchor.constraint(equalTo: view.centerXAnchor,constant: -10),optn1!.widthAnchor.constraint(equalToConstant: btnWidth),optn1!.heightAnchor.constraint(equalToConstant: btnHeight)])
        
        optn2 = UIButton()
        optn2!.backgroundColor = .black
        optn2!.layer.borderWidth = 2
        optn2!.layer.cornerRadius = 20
        optn2!.layer.borderColor = UIColor.white.cgColor
        optn2!.translatesAutoresizingMaskIntoConstraints = false
        optn2!.layer.zPosition = 1
        optn2!.tag = 2
        optn2!.setTitle(logicHandler.getOption(optionNumber: 1), for: .normal)
        optn2!.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        self.view.addSubview(optn2!)
        
        NSLayoutConstraint.activate([optn2!.topAnchor.constraint(equalTo: optn1!.topAnchor),optn2!.leftAnchor.constraint(equalTo: view.centerXAnchor,constant: 10),optn2!.heightAnchor.constraint(equalToConstant: btnHeight),optn2!.widthAnchor.constraint(equalToConstant: btnWidth)])
        
        
        let line2 = UIView()
        line2.backgroundColor = .white
        line2.layer.zPosition = 0
        line2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(line2)
        NSLayoutConstraint.activate([line2.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 40 + (btnHeight/2)),line2.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),line2.widthAnchor.constraint(equalToConstant: (3*btnWidth) + 20 ),line2.heightAnchor.constraint(equalToConstant: 3)])
        
        
        optn3 = UIButton()
        optn3!.backgroundColor = .black
        optn3!.tag = 3
        optn3!.layer.cornerRadius = 20
        optn3!.layer.borderWidth = 2
        optn3!.layer.borderColor = UIColor.white.cgColor
        optn3!.layer.zPosition = 1
        optn3!.translatesAutoresizingMaskIntoConstraints = false
        optn3!.setTitle(logicHandler.getOption(optionNumber: 2), for: .normal)
        optn3!.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        self.view.addSubview(optn3!)
        
        NSLayoutConstraint.activate([optn3!.topAnchor.constraint(equalTo: optn1!.bottomAnchor,constant: 20),optn3!.rightAnchor.constraint(equalTo: view.centerXAnchor,constant: -10),optn3!.widthAnchor.constraint(equalToConstant: btnWidth),optn3!.heightAnchor.constraint(equalToConstant: btnHeight)])
        
        optn4 = UIButton()
        optn4!.backgroundColor = .black
        optn4!.tag = 4
        optn4!.layer.cornerRadius = 20
        optn4!.layer.borderWidth = 2
        optn4!.layer.borderColor = UIColor.white.cgColor
        optn4!.layer.zPosition = 1
        optn4!.translatesAutoresizingMaskIntoConstraints = false
        optn4!.setTitle(logicHandler.getOption(optionNumber: 3), for: .normal)
        optn4!.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        self.view.addSubview(optn4!)
        
        
        NSLayoutConstraint.activate([optn4!.topAnchor.constraint(equalTo: optn2!.bottomAnchor,constant: 20),optn4!.leftAnchor.constraint(equalTo: view.centerXAnchor,constant: 10),optn4!.widthAnchor.constraint(equalToConstant: btnWidth),optn4!.heightAnchor.constraint(equalToConstant: btnHeight)])
        
        
        let line3 = UIView()
        line3.backgroundColor = .white
        line3.layer.zPosition = 0
        line3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(line3)
        NSLayoutConstraint.activate([line3.topAnchor.constraint(equalTo: optn1!.bottomAnchor,constant: 20+(btnHeight/2)),line3.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),line3.widthAnchor.constraint(equalToConstant: 3*btnWidth),line3.heightAnchor.constraint(equalToConstant: 3)])
        
        
        stakeLabel = UILabel()
        stakeLabel!.backgroundColor = .black
        stakeLabel!.translatesAutoresizingMaskIntoConstraints = false
        stakeLabel!.textAlignment = .center
        stakeLabel!.layer.masksToBounds = true
        stakeLabel!.text = logicHandler.getStake()
        stakeLabel!.textColor = .white
        stakeLabel!.font = stakeLabel!.font.withSize(40)
        stakeLabel!.backgroundColor = UIColor.black
        stakeLabel!.layer.borderWidth = 2
        stakeLabel!.layer.borderColor = UIColor.white.cgColor
        stakeLabel!.layer.cornerRadius = 5
        stakeLabel!.numberOfLines = 1
        
        self.view.addSubview(stakeLabel!)
        
        /*NSLayoutConstraint.activate([stakeLabel!.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),stakeLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),stakeLabel!.widthAnchor.constraint(equalToConstant: width ),stakeLabel!.heightAnchor.constraint(equalToConstant: 100)])*/
        
        NSLayoutConstraint.activate([stakeLabel!.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),stakeLabel!.rightAnchor.constraint(equalTo: view.centerXAnchor,constant: -10),stakeLabel!.widthAnchor.constraint(equalToConstant: btnWidth),stakeLabel!.heightAnchor.constraint(equalToConstant: btnHeight)])
        
        lifeline = UIButton()
        lifeline!.backgroundColor = .black
        lifeline!.layer.borderWidth = 2
        //lifeline!.layer.cornerRadius = 20
        lifeline!.layer.borderColor = UIColor.white.cgColor
        lifeline!.translatesAutoresizingMaskIntoConstraints = false
        
        lifeline!.tag = 5
        lifeline!.setTitle("50:50", for: .normal)
        lifeline!.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        lifeline!.addTarget(self, action: #selector(lifeLineAction), for: .touchUpInside)
        self.view.addSubview(lifeline!)
        
        NSLayoutConstraint.activate([lifeline!.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),lifeline!.leftAnchor.constraint(equalTo: view.centerXAnchor,constant: 10),lifeline!.heightAnchor.constraint(equalToConstant: btnHeight),lifeline!.widthAnchor.constraint(equalToConstant: btnWidth)])
        
        
        
    }
    
    
    
    //MARK: - SwiftUI modal handlers
    func showInfo(){
        
        //Create instance of SwiftUI class ViewModel
        let bridge = ViewModel()
        
        let vc = UIHostingController(rootView: ModalView(vm: bridge,info: logicHandler.getInfo()))
        
        //Implement ViewModel's method 'okAction'
        bridge.okAction = { [weak vc]in
            vc?.dismiss(animated: true){ [self] in
                
                //Display the next question 0.5s after the Modal has been dismissed.
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateQuestionAndOptions), userInfo: nil, repeats: false)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func wrongAnswer(){
        print("Wrong answer function")
        let bridge = ViewModel()
        
        let viewController = UIHostingController(rootView: DialogModal(dialogModalObj: bridge,info: logicHandler.getInfo()))
        
        bridge.dialogBox = { [weak viewController] in
            viewController?.dismiss(animated: true){ [self]in
                
                //Helper method of QuizLogicHandler to reset the quiz state and restart the game.
                self.logicHandler.resetQuestions()
                self.lifeline!.isEnabled = true
                self.lifeline!.backgroundColor = .black
                self.lifeline!.setTitle("50:50", for: .normal)
                self.lifeline!.isEnabled = true
                let title: NSMutableAttributedString = NSMutableAttributedString(string: "50:50")
                
                self.lifeline!.titleLabel?.attributedText = title
                self.lifelineUsed = false
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateQuestionAndOptions), userInfo: nil, repeats: false)
                
            }
        }
        
        self.present(viewController,animated: true, completion: nil)
    }
    
    
    //MARK: - Audio
    
    //Helper function to play game sounds, accepts a string argument which determines the audio to be played.
    func playSound(name resourceName:String){
        
        switch resourceName {
        case "start":
            let startSound = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: startSound)
                audioPlayer.play()
            }
            catch{
                print("Couldn't load resource")
            }
            break
            
        case "correct":
            let correctAnswer = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: correctAnswer)
                audioPlayer.play()
                audioPlayer.volume = 0.8
            }
            catch{
                print("Couldn't load resource")
            }
            break
        case "wrong":
            let wrongAnswer = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: wrongAnswer)
                audioPlayer.play()
                audioPlayer.volume = 0.8
            }
            catch{
                print("Couldn't load resource")
            }
            break
            
        case "cheering_and_applause":
            let win = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: win)
                audioPlayer.play()
                
            }
            catch{
                print("Couldn't load resource")
            }
                
            
            
            
        default:
            print("No default sound")
        }
        
        
    }
    

    //MARK: - Confetti
    
    func confettiExplosion() {
        //create an emitter layer instance.
        emitter = CAEmitterLayer()
        
        //Configure position and shape.
        emitter!.emitterPosition = CGPoint(x: (view.bounds.size.width)/2, y: view.bounds.size.height)
        emitter!.emitterShape = CAEmitterLayerEmitterShape.rectangle
        //emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        
        emitter!.emitterSize = view.bounds.size
        
        //Array of emitter cells
        emitter!.emitterCells = generateEmitterCells()
        
        //Add the effect on top of all the layers.
        emitter!.zPosition = 10
        
        //Add the emitter layer to the parent view
        self.view.layer.addSublayer(emitter!)
        
    }
    
    
    func generateEmitterCells() -> [CAEmitterCell] {
        
        var cells: [CAEmitterCell] = [CAEmitterCell]()
        
        for _ in 1..<16{
            
            let confettiParticles = ["confetti1","confetti2","confetti3"]
            
            //Create and fine tune emitter cell's attributes.
            cell = CAEmitterCell()
            cell!.birthRate = 4.0
            cell!.lifetimeRange = 0
            cell!.lifetime = 14.0
            cell!.velocity = 10
            cell!.velocityRange = 300
            cell!.emissionLongitude = CGFloat.pi
            cell!.emissionRange = CGFloat.pi / 2.0
            cell!.spin = 3.0
            cell!.spinRange = 0
            cell!.contents = UIImage(named: confettiParticles.randomElement()!)?.cgImage
            cell!.yAcceleration = -70
            cell!.scaleSpeed = -0.1
            cell!.scaleRange = 0.25
            cell!.scale = 0.1
            cells.append(cell!)
        }
        
        //Return array of emitter cells
        return cells
    }
    
    
    
    //MARK: - Restart
    func restartGame(){
        
        
        //Show victory messge and play again button
        winningLabel = UILabel()
        
        winningLabel!.text = "Congratulations, you won a million dollars 🤑"
        winningLabel!.translatesAutoresizingMaskIntoConstraints = false
        winningLabel!.textColor = .white
        winningLabel!.font = winningLabel!.font.withSize(60)
        winningLabel!.layer.zPosition = 20
        self.view.addSubview(winningLabel!)
        
        NSLayoutConstraint.activate([winningLabel!.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),winningLabel!.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30), winningLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),winningLabel!.widthAnchor.constraint(equalToConstant: 300),winningLabel!.heightAnchor.constraint(equalToConstant: 50)])
        
        
        playAgainButton = UIButton()
        playAgainButton!.setTitle("Play Again", for: .normal)
        playAgainButton!.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton!.backgroundColor = .black
        playAgainButton!.layer.borderWidth = 2
        playAgainButton!.layer.cornerRadius = 20
        playAgainButton!.layer.borderColor = UIColor.white.cgColor
        playAgainButton!.layer.zPosition = 20
        playAgainButton!.titleLabel?.font = playAgainButton!.titleLabel?.font.withSize(40)
        playAgainButton!.layer.borderColor = UIColor.white.cgColor
        playAgainButton!.addTarget(self, action: #selector(restart), for: .touchUpInside)
        
        self.view.addSubview(playAgainButton!)
        
        NSLayoutConstraint.activate([playAgainButton!.centerXAnchor.constraint(equalTo: view.centerXAnchor),playAgainButton!.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -20),playAgainButton!.widthAnchor.constraint(equalToConstant: 200),playAgainButton!.heightAnchor.constraint(equalToConstant: 100)])
        
        
        
    }
    
    
    
    //MARK: - Button actions
    
    @objc func updateQuestionAndOptions(){
        
        if !logicHandler.isOver(){
            questionLabel!.text = logicHandler.getQuestion()
            stakeLabel!.text = logicHandler.getStake()
            
            playSound(name: "start")
            
            optn1!.backgroundColor = .black
            optn2!.backgroundColor = .black
            optn3!.backgroundColor = .black
            optn4!.backgroundColor = .black
            
            optn1!.isEnabled = true
            optn2!.isEnabled = true
            optn3!.isEnabled = true
            optn4!.isEnabled = true
            
            optn1!.setTitle(logicHandler.getOption(optionNumber: 0), for: .normal)
            optn2!.setTitle(logicHandler.getOption(optionNumber: 1), for: .normal)
            optn3!.setTitle(logicHandler.getOption(optionNumber: 2), for: .normal)
            optn4!.setTitle(logicHandler.getOption(optionNumber: 3), for: .normal)
        }
        else{
            confettiExplosion()
            playSound(name: "cheering_and_applause")
            restartGame()
            PlaygroundPage.current.assessmentStatus = .pass(message: "That's awesome! Hearty congratulations on winning the title of 'Who wants to be a climate warrior' 🥳🥳\(getNextPage())")
            
        }
        
        
    }
    
    
    @objc func restart(sender: UIButton){
        logicHandler.resetQuestions()
        lifeline?.isEnabled = true
        lifeline?.backgroundColor = .black
        lifeline?.setTitle("50:50", for: .normal)
        lifeline?.isEnabled = true
        //Remove striekthrough if lifeline was used in the previous game.
        let title: NSMutableAttributedString = NSMutableAttributedString(string: "50:50")
        
        emitter?.birthRate = 0.0
        emitter?.lifetime = 0.0
        emitter?.removeAllAnimations()
        emitter?.removeFromSuperlayer()
        
        
        lifeline?.titleLabel?.attributedText = title
        lifelineUsed = false
        
        logicHandler.resetQuestions()
        updateQuestionAndOptions()
        winningLabel?.removeFromSuperview()
        playAgainButton?.removeFromSuperview()
    }
    
    @objc func btnPressed(sender: UIButton){
        
        print("Button pressed")
        //Conform to protocol and execute the function associated with the protocol.
        let obj = DelegateHandler()
        obj.delegate = self
        obj.runDelegateFunction(tag: sender.tag, sender: sender)
        
    }
    
    @objc func lifeLineAction(sender : UIButton){
        //Lifeline feature to erase two wrong options
        if !lifelineUsed {
            //Using helper functions from QuizLogicHandler to retrieve the correct answer for the current question.
            let ans = logicHandler.getAnswer()
            switch ans {
            //Disable clickability on the removed wrong options.
            case 0:
                optn2!.setTitle("", for: .normal)
                optn4!.setTitle("", for: .normal)
                optn2!.isEnabled = false
                optn4!.isEnabled = false
                break
            case 1:
                optn1!.setTitle("", for: .normal)
                optn4!.setTitle("", for: .normal)
                optn1!.isEnabled = false
                optn4!.isEnabled = false
                break
            case 2:
                optn1!.setTitle((""), for: .normal)
                optn2!.setTitle("", for: .normal)
                optn2!.isEnabled = false
                optn1!.isEnabled = false
                break
            case 3:
                optn2!.setTitle("", for: .normal)
                optn3!.setTitle("", for: .normal)
                optn2!.isEnabled = false
                optn3!.isEnabled = false
                break
                
            default:
                print("No default case")
                break
            }
            
            lifelineUsed = true
            
            //Mutate the lifeline label text to add a strikethrough, implying that it's been used
            let strikeThrough: NSMutableAttributedString = NSMutableAttributedString(string: "50:50")
            
            strikeThrough.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, strikeThrough.length))
            
            lifeline!.titleLabel?.attributedText = strikeThrough
            lifeline!.backgroundColor = .red
            
        }
        
    }
    
}

//MARK: - Protocol implementation
@available(iOS 13.0, *)
extension QuizViewController:AnswerDelegate{
    
    
    //Implement protocol function to verify user's response with actual answer.
    func answerPressed(btnIndex: Int,sender: UIButton) {
        
        let userAnswer = sender.tag - 1
        
        let correct = logicHandler.correctAnswer(userAnswer)
        
        if correct {
            print("Correct")
            
            
            
            if logicHandler.isOver() {
                showInfo()
                
                
            }
            else{
                playSound(name: "correct")
                showInfo()
                
                logicHandler.nextQuestion()
            }
            
            //logicHandler.nextQuestion()
            
            sender.backgroundColor = .green
            
        }
        else{
            print("Wrong")
            //showInfo()
            wrongAnswer()
            
            sender.backgroundColor = .red
            playSound(name: "wrong")
            
        }
        
        /*let alert = UIAlertController(title: "Ans", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default){ [self]_ in
            self.questionNumber += 1
            
            //updateQuestionAndOptions()
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateQuestionAndOptions), userInfo: nil, repeats: false)
        })
        self.present(alert, animated: true,completion: nil)*/
        
        
    }
}



extension UIView{
    func addBackground(){
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        //let height = frame.height
        
        let imageBackgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        imageBackgroundView.clipsToBounds = true
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //imageBackgroundView.center = self.view.center
        imageBackgroundView.image = UIImage(imageLiteralResourceName: "bg_template")
        
        //Maintain the aspect ratio of the image.
        imageBackgroundView.contentMode = .scaleAspectFill
        
        
        self.addSubview(imageBackgroundView)
        self.sendSubviewToBack(imageBackgroundView)
        
        //Position the image centered to the view and stretch across all the edges.
        NSLayoutConstraint.activate([imageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),imageBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),imageBackgroundView.topAnchor.constraint(equalTo:topAnchor),imageBackgroundView.bottomAnchor.constraint(equalTo:bottomAnchor),imageBackgroundView.leftAnchor.constraint(equalTo:leftAnchor),imageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor)])
        
    }
}


class PaddingLabel:UILabel{
    //Padding insets to UILabel
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}

//
//  DelegateHandler.swift
//  Book_Sources
//
//  Created by Prajwal Kulkarni on 11/04/21.
//

import UIKit


public class DelegateHandler{
    
    var delegate:AnswerDelegate?
    
    public func runDelegateFunction(tag index:Int, sender btnSender: UIButton){
        print("Run delegate")
        delegate?.answerPressed(btnIndex: index, sender: btnSender)
    }
    
}

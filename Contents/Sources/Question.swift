//
//  Question.swift
//  Book_Sources
//
//  Created by Prajwal Kulkarni on 16/04/21.
//



//Struct definiton for Question
struct Question{
    let question: String
    let options: [String]
    let answer:Int
    let info: String
    
    init(q:String,optns:[String],a:Int,i:String){
        question = q
        options = optns
        answer = a
        info = i
    }
}

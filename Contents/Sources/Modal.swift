//
//  Modal.swift
//  Book_Sources
//
//  Created by Prajwal Kulkarni on 11/04/21.
//


import SwiftUI

public class ViewModel {
    var okAction: () -> Void = {}
    
    var dialogBox: () -> Void = {}
}


//View to display brief information about the correct answer.
public struct ModalView: View {
    
    var vm:ViewModel
    var info: String
    
    @available(iOS 13.0.0, *)
    public var body: some View{
        VStack{
            Image(uiImage: UIImage(named: "WWTBACW")!)
                .resizable()
                .padding(.top,5)
                .frame(width: 200, height: 200, alignment: .center)
            Text(info)
                .font(.system(size: 30))
                .padding(20)
            
            Spacer()
            
            Button(action: {
                self.vm.okAction()
            }){
                Text("OK")
                    .padding()
                    
                    
            }.background(Color.black)
            .foregroundColor(.white)
            .padding(.bottom,20)
        }
    }
}


//View to display brief information about the correct answer, and a "Restart" button.
public struct DialogModal:View {
    
    var dialogModalObj:ViewModel
    var info: String
    @available(iOS 13.0.0, *)
    public var body: some View{
        VStack{
            Image(uiImage: UIImage(named: "WWTBACW")!)
                .resizable()
                .padding(.top,5)
                .frame(width: 200, height: 200, alignment: .center)
            Text(info)
                .font(.system(size: 30))
                .padding(20)
            
            Spacer()
            
            Button(action: {
                self.dialogModalObj.dialogBox()
            }){
                Text("Restart")
                    .padding()
                
                
            }.background(Color.black)
            .foregroundColor(.white)
            .padding(.bottom,20)
        }
        
    }
}



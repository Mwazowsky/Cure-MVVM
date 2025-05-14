//
//  ChatContactsCellView.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ChatContactsCVCURE: View {
    
    var body: some View {
        
        HStack(spacing: 4) {
            AvatarIVCURE()
            
            VStack(spacing: 4){
                NameTxtCURE(text: "Abdul Dudu")
                
                LastMsgTxtCURE(text: "Hey Babe Lol! XOXO")
            }
            
            TimeTxtCURE(text: "12:00 AM")
        }
    }
}

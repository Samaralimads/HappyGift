//
//  ListParticipantView.swift
//  HappyGift
//
//  Created by apprenant152 on 12/11/2025.
//

import SwiftUI

struct ListParticipantView: View {
    
    @State var participantVM = ParticipantViewModel()
    
    var body: some View {
        
            if participantVM.participants.isEmpty{
                VStack{
                    Text("Pas de participanr ")
                }
                
            }
        
      
    }
}

#Preview {
    ListParticipantView()
}

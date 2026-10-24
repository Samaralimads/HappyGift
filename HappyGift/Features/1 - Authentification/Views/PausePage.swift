//
//  PauseFile.swift
//  HappyGift
//
//  Created by caroletm on 23/02/2026.
//

import SwiftUI

struct PausePage: View {
    var body: some View {
        

            ZStack {
              
                Image(.backAuth2)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                
                GeometryReader { geo in
                    
                    let offsetPancarte = geo.size.width * 0.1
                    let heightPancarte = geo.size.height * 0.75
                    let widthPancarte = geo.size.width * 0.9
                    
                    let taillePapaNoel = geo.size.width * 0.25
                    
                    ZStack {
                        Image(.pancarte)
                            .resizable()
                            .frame(width : widthPancarte, height: heightPancarte)
                            .padding(20)
                        
                        VStack {
                            Text("My Secret Santa")
                                .font(.custom("Syncopate-Bold", size: 18))
                            Text("revient bientôt\n\n")
                                .font(.custom("Syncopate-Bold", size: 14))
                            Spacer()
                            Text("Les lutins sont en train de préparer les cadeaux...\n\nRendez vous en fin d'année! \n\nMerci de votre patience.")
                                .font(.system(size: 18, weight:.regular))
                            Spacer()
                            Image(.papaNoel)
                                .resizable()
                                .scaledToFit()
                                .frame(width: taillePapaNoel, height: taillePapaNoel)
                        }
                        .padding(10)
                        .multilineTextAlignment(.center)
                        .frame(width : widthPancarte - 50, height: heightPancarte - 200)
                        .offset(y : offsetPancarte)
                        
                        
                    }
                    .offset(y : offsetPancarte)
            }
        }
    }
}

#Preview {
    PausePage()
}


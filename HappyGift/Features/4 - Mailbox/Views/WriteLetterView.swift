//
//  letterView.swift
//  HappyGift
//
//  Created by alize suchon on 12/11/2025.
//

import SwiftUI

public struct WriteLetterView: View {
    
    @Environment(LetterViewModel.self) var letterVM
    @Environment(NavigationViewModel.self) var navigationVM
    @State private var showModal = false
    
    var event: EventDTO
    
    public var body: some View {
        
        @Bindable var letterVM = letterVM
        
//        iPhonePro
//        Largeur : 393 pt
//        Hauteur : 852 pt
        
        //iPad
//        Largeur : 834 pt
//        Hauteur : 1194 pt
        
        GeometryReader { geo in
            
            let w = geo.size.width
            let h = geo.size.height

            // ✅ même logique que LandingScreen / RecapEvent
            let screenRatio = w / h
            let isLargeScreen = screenRatio > 0.65

            // ✅ Reprise des bons réglages (mêmes ratios que RecapEvent)
            
            let PaperWidth = w * (isLargeScreen ? 3 : 1)
            let PaperHeight = h * (isLargeScreen ? 0.79 : 1)
            let RectBeigeWidth = w * (isLargeScreen ? 0.9 : 0.8)
            let RectBeigeHeight = h * (isLargeScreen ? 0.7 : 0.71)
            
            let TextEditorHeight = h * (isLargeScreen ? 0.45 : 0.45)
            let SignatureHeight = h * (isLargeScreen ? 0.05 : 0.05)
            let SignatureWidth = w * (isLargeScreen ? 0.28 : 0.28)
            
            let paddingLetterHorizontal = w * (isLargeScreen ? 0.05 : 0.1)
            let paddingLetterVertical = w * (isLargeScreen ? 0.20 : 0.25)
            
            let maxHeightPaper = h * (isLargeScreen ? 0.8 : 0.8)
            
            NavigationView {
                ZStack {
                    Color(.rose)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center) {
                        Text("Ma lettre")
                            .font(.custom("Syncopate-Bold", size: 30))
                            .padding(.top, 20)
                            .foregroundColor(.beige)
                        
                        // fond papier à lettre
                        ZStack(alignment: .topLeading) {
                            ZStack{
                                Image("letter")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow( color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    .frame(maxWidth: PaperWidth, maxHeight: PaperHeight)
                                    .ignoresSafeArea(edges: .horizontal)
                                Rectangle()
                                    .foregroundColor(.beige)
                                    .frame(width: RectBeigeWidth, height: RectBeigeHeight)
                                    .shadow( color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Cher père Noël,")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.leading, 0.8)
                                
                                // message
                                ZStack(alignment: .topLeading) {
                                    if letterVM.userMessage.isEmpty {
                                        Text("Écris ton message ici ...")
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                            .padding(.top, 8)
                                            .padding(.leading, 5)
                                    }
                                    TextEditor(text: $letterVM.userMessage)
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                        .lineSpacing(5)
                                        .frame(height: TextEditorHeight)
                                }
                                // Signature
                                HStack{
                                    Spacer()
                                    ZStack(alignment: .trailing) {
                                        if letterVM.signature.isEmpty {
                                            Text("Prénom")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18))
                                                .padding(.bottom, 5)
                                                .padding(.trailing, 2.5)
                                        }
                                        TextEditor(text: $letterVM.signature)
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(.black)
                                            .scrollContentBackground(.hidden)
                                            .background(Color.clear)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: SignatureWidth, height: SignatureHeight)
                                    }
                                }
                            }
                            .padding(.horizontal, paddingLetterHorizontal)
                            .padding(.vertical, paddingLetterVertical)
                        }
                        .frame(maxWidth: 600, maxHeight: maxHeightPaper)
                        .padding(.horizontal)
                        
                        Button {
                            Task {
                                navigationVM.isLoading = true
                                defer {navigationVM.isLoading = false}
                                guard let eventId = event.id else { return }
                                await letterVM.sendLetter(eventId: eventId)
                            }
                            
                            showModal = true
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.black)
                                    .frame(width: 250, height: 60)
                                Text("Envoyer ma lettre")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.beige)
                            }
                        }
                        
                        //Modale
                        .sheet(isPresented: $showModal){
                            SucessLetterModal(showModal: $showModal)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}


#Preview {
    WriteLetterView(event: santa1)
        .environment(LetterViewModel(userVM: UserViewModel()))
        .environment(NavigationViewModel())
}


// Extension pour cacher le clavier sur iOS/iPadOS
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


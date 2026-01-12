//
//  EventJoinView.swift
//  HappyGift
//
//  Created by apprenant152 on 13/11/2025.
//

import SwiftUI

struct EventJoinView: View {
    @Environment(EventViewModel.self) private var eventVM
    @Environment(UserViewModel.self) private var userVM
    @Environment(SnowfallVM.self) private var snowfallVM
    @Environment(\.dismiss) var dismiss
    @Environment(NavigationViewModel.self) private var navigationVM
    
    @State var showAlertEmptyCode: Bool = false
    
    var body: some View {
        @Bindable var eventVM = eventVM
        
        ZStack {
            Color.beige.ignoresSafeArea()
            
            VStack {
                
                // Image avec neige
                ZStack {
                    Image("bonnetNoel")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 300)
                    
                    SnowfallView()
                }
                
                // TextField avec label
                VStack(spacing: 12) {
                    Text("Code santa")
                        .font(.system(size: 16, weight: .bold))
                    
                    TextField("", text: $eventVM.codeEvent)
                        .padding(.horizontal, 10)
                        .frame(width: 140, height: 40)
                        .background(.white.opacity(0.8))
                        .cornerRadius(10)
                        .font(.custom("Syncopate-Bold", size: 20))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Bouton
                ButtonParticipantCellView(title: "Rejoindre", function: {
                    if !eventVM.codeEvent.isEmpty {
                        Task {
                            navigationVM.isLoading = true
                            defer { navigationVM.isLoading = false }
                            await eventVM.joinEvent(email: userVM.email, code: eventVM.codeEvent)
                            eventVM.codeEvent = ""
                        }
                    } else {
                        showAlertEmptyCode = true
                    }
                }, size: 274)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Mon événement")
                    .font(.custom("Syncopate-Bold", size: 20))
                    .foregroundStyle(.black)
            }
        }
        .sheet(isPresented: $eventVM.showValidationJoinModal) {
            EventValidJoinCellView()
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $showAlertEmptyCode) {
            Alert(title: Text("Veuillez saisir un code."))
        }
        .alert(isPresented: $eventVM.showInvalidCodeAlert) {
            Alert(title: Text("Ce code ne correspond à aucun évènement"))
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    EventJoinView()
        .environment(EventViewModel())
        .environment(SnowfallVM())
        .environment(UserViewModel())
        .environment(NavigationViewModel())
}

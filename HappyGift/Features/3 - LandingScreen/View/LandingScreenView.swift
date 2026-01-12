//
//  LandingScreenView.swift
//  HappyGift
//
//  Created by Apprenant125 on 12/11/2025.
//

import SwiftUI

struct LandingScreenView: View {
    
    @Environment(LandingScreenViewModel.self) var landingVM
    @Environment(NavigationViewModel.self) var navVM
    @Environment(EventViewModel.self) var eventVM
    @Environment(SnowfallVM.self) var snowfallVM
    @Environment(LetterViewModel.self) var letterVM
    @Environment(AuthViewModel.self) var authVM
    @Environment(UserViewModel.self) var userVM
    
    @State var showLogoutModal: Bool = false
    @State private var pulse = false
    @State var isFlipped = false
    
    var body: some View {
        
        @Bindable var landingVM = landingVM
        


            GeometryReader { geo in
                
                // CALCULS ADAPTATIFS
                let screenRatio = geo.size.width / geo.size.height
                let isLargeScreen = screenRatio > 0.65
                
                // Variables adaptatives selon le type d'écran
                let hStackPaddingBottom = isLargeScreen ? 0.80 : 0.90
                
                
                ZStack {
                    Color.vert
                        .ignoresSafeArea()
                    SnowfallView2()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hello \(userVM.name)!")
                            .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.065, 30)))
                            .foregroundStyle(.white)
                            .padding(.leading, geo.size.width * 0.06)
                            .padding(.top, geo.size.width * 0.1)
                            .padding(.bottom, geo.size.width * 0.1)
                            .transaction { $0.animation = nil }
                        
                        Spacer()
                        
                        // Section neige et éléments
                        ZStack(alignment: .bottom) {
                            // Font gris
                            Image(.neigeFontDark)
                                .resizable()
                                .scaledToFill()
                                .allowsHitTesting(false)
                                .frame(height: geo.size.height * 0.38)
                                .transaction { $0.animation = nil }
                            
                            // Font blanc
                            Image(.neigeFont)
                                .resizable()
                                .scaledToFill()
                                .allowsHitTesting(false)
                                .frame(height: geo.size.height * 0.40)
                                .offset(y: 5)
                                .transaction { $0.animation = nil }
                            
                            // Contenu sur la neige
                            HStack(alignment: .bottom, spacing: geo.size.width * 0.03) {
                                
                                // Boîte aux lettres
                                Button {
                                    navVM.path.append(AppRoute.mailbox)
                                } label: {
                                    VStack(spacing: -8) {
                                        Image(letterVM.mailboxData.isEmpty ? .boiteAuxLettresVide : .boiteAuxLettres)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.28, height: geo.size.width * 0.28)
                                        Image(.ombreBoite)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.25)
                                    }
                                    .offset(y :  geo.size.width * 0.040)
                                }
                                
                                // Bonhomme de neige
                                if let lastLetter = letterVM.lastLetter,
                                   letterVM.lastLetterIsRead == false {
                                    Button {
                                        navVM.path.append(
                                            AppRoute.enveloppeView(letter: lastLetter)
                                        )
                                    } label: {
                                        VStack(spacing: -5) {
                                            Image(.bulleLettre)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geo.size.width * 0.18)
                                            Image(.bonhomme)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geo.size.width * 0.20)
                                        }
                                    }
                                    .offset(y : geo.size.width * 0.05)
                                    
                                } else {
                                    Image(.bonhomme)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.20)
                                        .rotationEffect(Angle(degrees: pulse ? -5 : 5))
                                        .offset(y :  geo.size.width * 0.05)

                                }
                                
                                Spacer()
                                
                                // Maison rose deconnexion
                                Button {
                                    showLogoutModal = true
                                } label: {
                                    Image(.maisonsRose)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(
                                            color: Color.white.opacity(pulse ? 1 : 0.2),
                                            radius: pulse ? 15 : 5
                                        )
    
                                }
                                .frame(width: geo.size.width * 0.28, height: geo.size.width * 0.3)
                                .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.02)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                        pulse.toggle()
                                    }
                                }
                            }
                            .padding(.horizontal, geo.size.width * 0.06)
                            .padding(.bottom, geo.size.width * hStackPaddingBottom)
                        }
                    }
                    
                    //COUNTDOWN
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Countdown(geo : geo)
                            .padding(.bottom, 8)
                            .onAppear {
                                landingVM.startTimer()
                            }
                        
                        //BOUTONS LANDING SCREEN
                        ButtonsLandingScreen(geo : geo)
                        
                    }
                    .padding(.bottom, 10)
                }
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            Task {
                navVM.isLoading = true
                defer { navVM.isLoading = false }
                
                async let events: () = eventVM.fetchEvents()
                async let letters: () = letterVM.fetchLetters()
                
                _ = await (events, letters)
            }
        }
        .sheet(isPresented: $showLogoutModal) {
            LogoutModal(showLogoutModal: $showLogoutModal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    let eventVM = EventViewModel()
    let userVM = UserViewModel()
    NavigationStack {
        LandingScreenView()
            .environment(LetterViewModel(userVM: userVM))
            .environment(LandingScreenViewModel(eventVM: eventVM))
            .environment(NavigationViewModel())
            .environment(eventVM)
            .environment(AuthViewModel(userVM: userVM))
            .environment(SnowfallVM(
                numberOfSnowflakes: 120,
                area: .rect,
                height: 490
            ))
            .environment(userVM)
    }
}

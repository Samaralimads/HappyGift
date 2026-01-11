//
//  RecapEvent.swift
//  HappyGift
//
//  Created by caroletm on 12/11/2025.
//

import SwiftUI

struct RecapEvent: View {

    @Environment(EventViewModel.self) private var eventVM
    @Environment(NavigationViewModel.self) private var navigationVM
    @Environment(UserViewModel.self) private var userVM

    @State var showAlert: Bool = false
    @State var showAlertParticipant: Bool = false
    @State var showAlertMinParticipants: Bool = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // ✅ même logique que LandingScreen
            let screenRatio = w / h
            let isLargeScreen = screenRatio > 0.65

            // Réglages simples iPad vs iPhone
            let topCardY = -h * (isLargeScreen ? 0.22 : 0.28)

            let lieuY = h * (isLargeScreen ? 0.05 : 0.03)
            let dateX = w * (isLargeScreen ? 0.05 : 0.08)
            let dateY = h * (isLargeScreen ? 0.05 : 0.01)

            // Cartes du bas : sur iPad on les remonte un peu + on réduit un peu l’échelle
            let bottomCardsScale: CGFloat = isLargeScreen ? 0.88 : 1.0
            let participantsX = w * (isLargeScreen ? 0.4 : 0.38)
            let participantsY = h * (isLargeScreen ? 0.35 : 0.28)

            let budgetX = -w * (isLargeScreen ? 0.24 : 0.28)
            let budgetY = h * (isLargeScreen ? 0.3 : 0.28)

            ZStack {
                Color.beige.ignoresSafeArea()

                ZStack {
                    // Carte nom + description (haut)
                    CarreNomDescriptionEvent()
                        .offset(y: topCardY)

                    // Lieu + date
                    HStack {
                        CarreRoseLieuEvent()
                            .offset(y: lieuY)

                        CarreRougeDateEvent()
                            .rotationEffect(.degrees(-12))
                            .padding(.top, h * 0.02)
                            .offset(x: dateX, y: dateY)
                    }

                    // ✅ Cartes du bas (scale iPad)
                    CarreListeParticipants()
                        .scaleEffect(bottomCardsScale)
                        .offset(x: participantsX, y: participantsY)
                        .rotationEffect(.degrees(15))

                    CarreVertBudgetPlus()
                        .scaleEffect(bottomCardsScale)
                        .rotationEffect(.degrees(-15))
                        .offset(x: budgetX, y: budgetY)

                    // Bouton en bas
                    VStack {
                        Spacer()

                        Button {
                            Task {
                                if !eventVM.participants.contains(where: {
                                    $0.email.lowercased() == userVM.email.lowercased()
                                }) {
                                    showAlertParticipant = true
                                    return
                                }

                                if eventVM.participants.count < 3 {
                                    showAlertMinParticipants = true
                                    return
                                }

                                if !eventVM.isValidFormEvent2 {
                                    showAlert = true
                                    return
                                }

                                navigationVM.isLoading = true
                                defer { navigationVM.isLoading = false }

                                await eventVM.createEvent()
                                eventVM.hasJustCreatedEvent = true

                                if let event = eventVM.currentEvent {
                                    navigationVM.path.append(
                                        AppRoute.tirageView(event: event, showbackButton: false)
                                    )
                                }
                            }
                        } label: {
                            ButtonText(
                                text: "Lancer le tirage",
                                width: w * (isLargeScreen ? 0.38 : 0.50)
                            )
                        }
                        .disabled(navigationVM.isLoading)

                        // ⚠️ ne jamais mettre -16 : ça peut couper
//                        .padding(.bottom, max(geo.safeAreaInsets.bottom, 12) + 12)
                    }
                }
            }
        }
        .alert("Tirage impossible", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Vous n'avez pas défini de budget ou ajouté de participants")
        }
        .alert("Tirage impossible", isPresented: $showAlertMinParticipants) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Il vous faut au minimum 3 participants pour lancer un tirage")
        }
        .alert("Tirage impossible", isPresented: $showAlertParticipant) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Ajoutez votre mail dans la liste des participants")
        }
    }
}

#Preview {
    RecapEvent()
        .environment(EventViewModel())
        .environment(NavigationViewModel())
        .environment(UserViewModel())
}




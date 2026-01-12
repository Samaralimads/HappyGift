//
//  DetailEvent.swift
//  HappyGift
//
//  Created by caroletm on 13/11/2025.
//

import SwiftUI

struct DetailEvent: View {

    @Environment(EventViewModel.self) private var eventVM
    @Environment(NavigationViewModel.self) private var navigationVM
    @Environment(LetterViewModel.self) private var letterVM
    @Environment(AuthViewModel.self) private var authVM

    var event: EventDTO

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // ✅ même logique que LandingScreen / RecapEvent
            let screenRatio = w / h
            let isLargeScreen = screenRatio > 0.65

            // ✅ Reprise des bons réglages (mêmes ratios que RecapEvent)
            let topCardY = -h * (isLargeScreen ? 0.22 : 0.28)

            let lieuY = h * (isLargeScreen ? 0.05 : 0.03)
            let dateX = w * (isLargeScreen ? 0.05 : 0.08)
            let dateY = h * (isLargeScreen ? 0.05 : 0.01)

            let bottomCardsScale: CGFloat = isLargeScreen ? 0.88 : 1.0

            // (équivalent à participants)
            let resultX = w * (isLargeScreen ? 0.40 : 0.38)
            let resultY = h * (isLargeScreen ? 0.35 : 0.28)

            let budgetX = -w * (isLargeScreen ? 0.24 : 0.28)
            let budgetY = h * (isLargeScreen ? 0.30 : 0.28)

            ZStack {
                Color.beige.ignoresSafeArea()

                ZStack {
                    // Haut
                    CarreNomDescriptionEvent2(event: event)
                        .offset(y: topCardY)

                    // Lieu + date
                    HStack {
                        CarreRoseLieuEvent2(event: event)
                            .offset(y: lieuY)

                        CarreRougeDateEvent2(event: event)
                            .rotationEffect(.degrees(-12))
                            .padding(.top, h * 0.02)
                            .offset(x: dateX, y: dateY)
                    }

                    // Résultat tirage
                    CarreResultatTirage(event: event)
                        .scaleEffect(bottomCardsScale)
                        .offset(x: resultX, y: resultY)
                        .rotationEffect(.degrees(15))

                    // Budget
                    CarreVertBudget(event: event)
                        .scaleEffect(bottomCardsScale)
                        .rotationEffect(.degrees(-15))
                        .offset(x: budgetX, y: budgetY)

                    // Bouton bas
                    VStack {
                        Spacer()

                        Button {
                            navigationVM.path.append(AppRoute.writeLetter(event: event))
                        } label: {
                            ButtonText(
                                text: "Ecrire à mon pere noel",
                                width: w * (isLargeScreen ? 0.6 : 0.70)
                            )
                        }

//                        // ✅ safe area propre (pas de -16)
//                        .padding(.bottom, max(geo.safeAreaInsets.bottom, 12) + 12)
                    }
                }
            }
        }
    }
}
#Preview {
    let eventVM = EventViewModel()
    let userVM = UserViewModel()
    DetailEvent(event: santa1)
        .environment(eventVM)
        .environment(NavigationViewModel())
        .environment(LetterViewModel(userVM: userVM))
        .environment(AuthViewModel(userVM: userVM))
}







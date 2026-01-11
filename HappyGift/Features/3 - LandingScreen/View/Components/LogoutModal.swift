//
//  LogoutModal.swift
//  HappyGift
//
//  Created by caroletm on 10/12/2025.
//

import SwiftUI

struct LogoutModal: View {
    
    @Environment(NavigationViewModel.self) var navigationVM
    @Environment(AuthViewModel.self) var authVM
    
    @Binding var showLogoutModal : Bool
    
    @State var action : LogoutAction = .deconnecter
    
    enum LogoutAction: CaseIterable, Hashable {
        case deconnecter
        case supprimerCompte
    }
    
    @State var showAlertDeleteAccount: Bool = false
    
@ViewBuilder
    func imageView(for image : LogoutAction) -> some View {
        switch image {
        case .deconnecter:
            Image(.maisonsRose)
        case .supprimerCompte:
            Image(.maisonsGrise)
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            // Largeur lisible (évite le “vide” sur iPad)
            let contentMaxWidth = min(geo.size.width * 0.92, 520)
            
            // Tailles adaptatives bornées (pour garder ton style)
            let titleFont = min(max(geo.size.width * 0.055, 18), 24)
            let bodyFont  = min(max(geo.size.width * 0.040, 15), 18)
            
            
            ZStack {
                Color(.beige)
                    .ignoresSafeArea()
                VStack (spacing: 20){
                    Rectangle()
                        .frame(width: 52, height: 5)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .padding(10)
                    
                    Text(action == .deconnecter
                         ? "Deconnexion"
                         : "Supprimer son compte")
                    .font(.custom("Syncopate-Bold", size: titleFont))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, 12)
                    
                    TabView (selection: $action){
                        ForEach(LogoutAction.allCases, id : \.self) { item in
                            imageView(for: item)
                                .frame(maxWidth: contentMaxWidth)
                                .tag(item)
                        }
                    }
                    .frame(height: 160)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    HStack(spacing: 8) {
                        ForEach(LogoutAction.allCases, id : \.self) { item in
                            Circle()
                                .fill(action == item ? Color.white : Color.black.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text(action == .deconnecter
                         ? "Êtes-vous sûr·e de vouloir vous déconnecter ?"
                         : "Êtes-vous sûr·e de vouloir supprimer votre compte ?")
                    .foregroundColor(.black)
                    .font(.system(size: bodyFont))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    Button {
                        if action == .deconnecter {
                            authVM.logout()
                        } else {
                            showAlertDeleteAccount = true
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(action == .deconnecter ? Color.black : Color.rouge)
                                .frame(width: 250, height: 60)
                            Text(action == .deconnecter
                                 ? "Se deconnecter"
                                 : "Supprimer mon compte")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.beige)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlertDeleteAccount) {
            Alert(
                   title: Text("Supprimer votre compte"),
                   message: Text("Vos données seront supprimées, cette action est irréversible et vous serez déconnecté."),
                   primaryButton: .destructive(Text("Oui, supprimer")) {
                       Task {
                           showLogoutModal = false
                            await authVM.deleteAccount()
                       }
                   },
                   secondaryButton: .cancel(Text("Annuler"))
               )
        }
        .presentationDetents([.fraction(0.7)])
    }
}

#Preview {
    let userVM = UserViewModel()
    LogoutModal(showLogoutModal: .constant(false))
        .environment(NavigationViewModel())
        .environment(AuthViewModel(userVM : userVM))
}

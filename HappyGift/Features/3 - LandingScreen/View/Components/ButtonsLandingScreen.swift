//
//  ButtonsLandingScreen.swift
//  HappyGift
//
//  Created by Apprenant125 on 12/11/2025.
//

import SwiftUI

struct ButtonsLandingScreen: View {
    @Environment(NavigationViewModel.self) var navVM
    
    var geo : GeometryProxy

    var body: some View {
        
            VStack(spacing: geo.size.height * 0.02) {
                // Bouton Créer un secret santa
                Button {
                    navVM.path.append(AppRoute.createEvent)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: geo.size.height * 0.12)
                        .foregroundStyle(.vert)
                        .overlay {
                            Rectangle()
                                .frame(height: geo.size.height * 0.03)
                                .foregroundStyle(.rouge)
                                .padding(.bottom, geo.size.height * 0.045)
                        }
                        .overlay {
                            Rectangle()
                                .frame(width: geo.size.width * 0.08)
                                .foregroundStyle(.rouge)
                                .border(.rougeDark, width: 1.5)
                                .padding(.trailing, geo.size.width * 0.55)
                        }
                        .overlay {
                            Text("Créer un secret santa")
                                .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.032, 14)))
                                .foregroundStyle(.beige)
                                .padding(.top, geo.size.height * 0.065)
                                .padding(.leading, geo.size.width * 0.3)
                        }
                }
                .buttonStyle(.plain)
                
                // Bouton Voir mes secret santa
                Button {
                    navVM.path.append(AppRoute.listEvent)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: geo.size.height * 0.12)
                        .foregroundStyle(.rose)
                        .overlay {
                            VStack(spacing: geo.size.height * 0.01) {
                                Image(.sucreOrge)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.05)
                                Text("Voir mes secret santa")
                                    .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.032, 14)))
                                    .foregroundStyle(.beige)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, geo.size.width * 0.06)
    }
}

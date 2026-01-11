//
//  Countdown.swift
//  HappyGift
//
//  Created by Apprenant125 on 12/11/2025.
//


import SwiftUI

struct Countdown: View {
    @Environment(LandingScreenViewModel.self) var landingVM
    
    var geo : GeometryProxy

    var body: some View {
      
            VStack {
                // Titre
                HStack {
                    Text("Prochain évènement")
                        .font(.system(size: min(geo.size.width * 0.042, 18), weight: .bold))
                        .padding(.leading, geo.size.width * 0.08)
                        .padding(.bottom, geo.size.height * 0.02)
                    Spacer()
                }

                // Compteur
                HStack(spacing: geo.size.width * 0.025) {
                    // Jours
                    VStack {
                        Text("jours")
                            .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.024, 9)))
                            .padding(.bottom, 5)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                            .foregroundStyle(.white)
                            .overlay {
                                Text(landingVM.formattedBackupTimeLeft.days)
                                    .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.06, 24)))
                                    .foregroundStyle(.vertDark)
                                    .contentTransition(.numericText(countsDown: true))
                            }
                    }

                    // Séparateur
                    VStack {
                        Circle()
                            .frame(width: geo.size.width * 0.025)
                            .foregroundStyle(.grisDark)
                        
                        Circle()
                            .frame(width: geo.size.width * 0.025)
                            .foregroundStyle(.grisDark)
                    }
                    
                    // Heures
                    VStack {
                        Text("heures")
                            .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.024, 9)))
                            .padding(.bottom, 5)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                            .foregroundStyle(.white)
                            .overlay {
                                Text(landingVM.formattedBackupTimeLeft.hours)
                                    .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.06, 24)))
                                    .foregroundStyle(.vertDark)
                                    .contentTransition(.numericText(countsDown: true))
                            }
                    }

                    // Séparateur
                    VStack {
                        Circle()
                            .frame(width: geo.size.width * 0.025)
                            .foregroundStyle(.grisDark)
                        
                        Circle()
                            .frame(width: geo.size.width * 0.025)
                            .foregroundStyle(.grisDark)
                    }

                    // Minutes
                    VStack {
                        Text("minutes")
                            .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.024, 9)))
                            .padding(.bottom, 5)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                            .foregroundStyle(.white)
                            .overlay {
                                Text(landingVM.formattedBackupTimeLeft.minutes)
                                    .font(.custom("Syncopate-Bold", size: min(geo.size.width * 0.06, 24)))
                                    .foregroundStyle(.vertDark)
                                    .contentTransition(.numericText(countsDown: true))
                            }
                    }
                }
        }
    }
}


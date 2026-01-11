//
//  SnowfallView2.swift
//  HappyGift
//
//  Created by caroletm on 11/01/2026.
//

import SwiftUI

struct SnowfallView2: View {
    @Environment(SnowfallVM.self) var snowfallVM
    
    var size: CGFloat
    
    init(size: CGFloat = 200, snowCount: Int = 80) {
        self.size = size
    }
    
    var body: some View {
        Canvas { context, _ in
            for flake in snowfallVM.snowflakes {
                let rect = CGRect(
                    x: flake.x - flake.size,
                    y: flake.y - flake.size,
                    width: flake.size * 2,
                    height: flake.size * 2
                )
                
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.gris)
                )
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

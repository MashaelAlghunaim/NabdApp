//
//  SplashScreen.swift
//  SaudiChatGPT
//
//  Created by Lamia AlSiddiqi on 25/08/1444 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        
        if isActive {
            OnBoarding()
        } else{
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack{
                    Image("NabdLogo")
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear(){
                            withAnimation(.easeIn(duration: 2.5)){ self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ self.isActive = true
                    
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

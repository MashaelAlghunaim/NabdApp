//
//  OnBoarding.swift
//  SaudiChatGPT
//
//  Created by Lamia AlSiddiqi on 25/08/1444 AH.
//

import SwiftUI

struct OnBoarding: View {
   
    @AppStorage("_shouldShowOnBoarding") var shouldShowOnBoarding: Bool = true
    
    var body: some View {
        InvestigationView()
        .fullScreenCover(isPresented: $shouldShowOnBoarding, content: {
            OnBoardingView(shouldShowOnBoarding: $shouldShowOnBoarding)
            
        })
    }
}

//OnBoarding

struct OnBoardingView: View {
    @Binding var shouldShowOnBoarding: Bool
    
    var body: some View {
        NavigationView{
            TabView {
                PageView(
                    title: "استغلال الوقت إلى حين وصول الإسعاف",
                    image: "OnBoarding1",
                    showsDismissButton: false,
                    shouldShowOnBoarding: $shouldShowOnBoarding
                )
                
                PageView(
                    title: "اتباع الخطوات اللّازمة للإسعافات الأوليّة",
                    image: "OnBoarding2", showsDismissButton: false,
                    shouldShowOnBoarding: $shouldShowOnBoarding
                    
                )
                
                PageView(
                    //title: "a",
                    title: "", image: "OnBoarding3",
                    showsDismissButton: true,
                    shouldShowOnBoarding: $shouldShowOnBoarding
                    
                )
                
                
            }
            .tabViewStyle(PageTabViewStyle()).indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
        } .navigationBarBackButtonHidden(true)
    }
}

struct PageView: View {
    let title: String?
    let image: String
    let showsDismissButton: Bool
    @State private var showAlert = false
    @State private var navigateToNextView = false
    @Binding var shouldShowOnBoarding: Bool
    @State var isPresent = false
    
    var body: some View {
            VStack {
                if !showsDismissButton {
                    HStack{
                        
                        Button(action: {
                            
                            shouldShowOnBoarding.toggle()
                            isPresent = true
                            
                           
                            
                        }, label: {
                            Text("تخطي")
                                .foregroundColor(Color("Blue1"))
                                .bold()
                                .padding(.leading, 290)
                                .padding(.top, -90)
                                .fullScreenCover(isPresented: $isPresent) {
                                    InvestigationView()
                                }
                        })
                    }
                    
                }
                
//                NavigationLink(destination: ContentView(), isActive: $navigateToNextView) {
//
//                }
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 400)
                    .padding()
                
                Text(title ?? "error")
                    .font(.system(size: 32))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                
                
                if showsDismissButton {
                    Button(action: {
                        
                        showAlert = true
                        
                        
                    }) {
                        Text("ابدأ المحادثة")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 60)
                            .background(Color("Blue1"))
                            .cornerRadius(15)
                            .padding(.bottom, 10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("تنبيه"), message: Text("هذا التطبيق لا يقوم بتشخيص طبي ولكن يقوم بتقديم الخطوات الإسعافية اللّازمة للحالة"), primaryButton: .default(Text("الموافقة")) {
                            navigateToNextView = true
                        }, secondaryButton: .cancel(Text("الغاء")))
                    }
                    NavigationLink(destination: InvestigationView(), isActive: $navigateToNextView) {
                        
                    }
                }
                
            }
        
    }
}
struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(shouldShowOnBoarding: .constant(true))
    
    
           
    }
}

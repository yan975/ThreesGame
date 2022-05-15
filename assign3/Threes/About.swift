//
//  About.swift
//  assign3
//
//  Created by Yan Pinglan on 4/18/22.
//

import SwiftUI

struct About: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var count = 1.0
    @State private var rotate = 360.0
    @State var flag = false
        
        var body: some View {
            if verticalSizeClass == .regular {
                A1()
            } else {
                HStack {
                    ZStack {
                        
                        if flag == true {
                            HStack(alignment: .center, spacing: 320) {
                                Text("Assign 3\nIs\nSo Hard!!!")
                                    .font(.system(size: 40))
                                    .fontWeight(.heavy)
                                    .lineSpacing(10)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.yellow)
                                    .frame(width: 310, height: 200, alignment: .center)
                                    .background(.white)
                                    .animation(.easeInOut(duration: 5))
                                    .padding()
                                
                                
                                Text("CMSC436")
                                    .font(.system(size: 16))
                                    .frame(width: 120, height: 120, alignment: .top)
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .overlay(Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width: 50, height: 50, alignment: .bottom)
                                                .foregroundColor(.red))
                                    .rotationEffect(.degrees(rotate))
                                    .animation(Animation.easeIn(duration: 5)
                                                .repeatForever(autoreverses: true))
                                    .onAppear(perform: {
                                        rotate = 720
                                    })
                                    .padding()
                                
                            }
                        }
                        
                        Button("Tap me") {
                            aboutF2()
                        }
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .padding(60)
                        .background(.blue)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.blue)
                                .scaleEffect(count)
                                .opacity(2-count)
                                .animation(
                                    .easeInOut(duration: 2)
                                        .repeatForever(autoreverses: false), value: count
                                )
                        )
                        .onAppear {
                            count = 2
                        }
                    }
                }
            }
        }
    func aboutF2() {
        flag = true
    }
    
}

struct A1: View {
    
    @State private var count = 1.0
    @State var flag = false
    
    var body: some View {
        VStack {
            ZStack {
                
                if flag == true {
                    A2()
                }
                
                Button("Tap me") {
                    aboutF1()
                }
                .font(.system(size: 30))
                .foregroundColor(.black)
                .padding(60)
                .background(.blue)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.blue)
                        .scaleEffect(count)
                        .opacity(2-count)
                        .animation(
                            .easeInOut(duration: 2)
                                .repeatForever(autoreverses: false), value: count
                        )
                )
                .onAppear {
                    count = 2
                }
            }
        }
        
    }
    
    func aboutF1() {
        flag = true
    }
}

struct A2: View {
    
    @State private var rotate = 360.0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 320) {
            Text("Assign 3\nIs\nSo Hard!!!")
                .font(.system(size: 40))
                .fontWeight(.heavy)
                .lineSpacing(10)
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                .frame(width: 310, height: 200, alignment: .center)
                .background(.white)
                .animation(.easeInOut(duration: 5))
                .padding()
            
            
            Text("CMSC436")
                .font(.system(size: 16))
                .frame(width: 120, height: 120, alignment: .top)
                .background(.yellow)
                .cornerRadius(20)
                .overlay(Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .bottom)
                            .foregroundColor(.red))
                .rotationEffect(.degrees(rotate))
                .animation(Animation.easeIn(duration: 5)
                            .repeatForever(autoreverses: true))
                .onAppear(perform: {
                    rotate = 720
                })
                .padding()
            
        }
    }
}


struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
.previewInterfaceOrientation(.landscapeRight)
    }
}

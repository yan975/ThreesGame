//
//  HomeView.swift
//  assign3
//
//  Created by Yan Pinglan on 4/18/22.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var triples: Triples
    var body: some View {
        TabView {
            MainView().tabItem {
                        Label("Board", systemImage: "gamecontroller")
            }
            Scores().tabItem {
                        Label("Scores", systemImage: "list.dash")
            }
            About().tabItem {
                        Label("About", systemImage: "info.circle")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}

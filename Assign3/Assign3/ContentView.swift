//
//  ContentView.swift
//  Assign3
//
//  Created by Hai Le on 4/11/21.
//

import SwiftUI

struct ContentView: View {
     var list:ScoreList = ScoreList()
    
    var body: some View {
        TabView {
            BoardView()
                .tabItem() {
                    Label("Board", systemImage: "gamecontroller")
                }
            ScoreView()
                .tabItem() {
                    Label("Scores", systemImage: "list.dash")
                }
            AboutView()
                .tabItem() {
                    Label("About", systemImage: "info.circle")
                }
        }.environmentObject(list)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




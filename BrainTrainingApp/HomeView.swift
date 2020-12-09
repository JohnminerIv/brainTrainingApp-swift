//
//  HomeView.swift
//  BrainTrainingApp
//
//  Created by John Miner on 12/3/20.
//

import SwiftUI

struct HomeView: View {
    @State var highScore: Int = 000
    var body: some View {
        NavigationView {
            VStack(spacing: 100){
                Text("Your high Score is \(highScore)")
                NavigationLink(destination: ContentView(highScore: $highScore)) {
                    Text("Start Game")
                }
            }
            .navigationBarTitle("Colorful Brain Game")
        }
    }
}

struct PauseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var gameState: GameState
    var body: some View {
        VStack(spacing: 100){
            Text("Paused")
            Button(action: {
                gameState.time = gameState.pausedTime
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Continue")
            })
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

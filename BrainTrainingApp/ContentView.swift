//
//  ContentView.swift
//  BrainTrainingApp
//
//  Created by John Miner on 11/30/20.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

enum myColors: String {
    case black = "Black"
    case red = "Red"
    case green = "Green"
    case yellow = "Yellow"
    case blue = "Blue"
    case magenta = "Magenta"
    case cyan = "Cyan"
    case white = "White"

    func value() -> Color {
        switch self {
        case .black: return .black
        case .red: return .red
        case .green: return .green
        case .yellow: return .yellow
        case .blue: return .blue
        case .magenta: return Color(hex: 0xFF00FF)
        case .cyan: return Color(hex: 0x00FFFF)
        case .white: return .white
        }
    }
    static func all() -> [myColors] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white]
    }
    static func randomColor() -> myColors {
        return myColors.all()[Int.random(in: 0...myColors.all().count - 1)]
    }
    static func randomForColorValue(color: myColors) -> myColors {
        if Int.random(in: 0...1) > 0 {
            return color
        }
        else {
            return myColors.randomColor()
        }
    }
    static func matches(color1: myColors, color2:myColors) -> Bool{
        return color1 == color2
    }
}

struct GameState {
    var topText: myColors = myColors.randomColor()
    var bottomText: myColors = myColors.randomColor()
    var colorText: myColors = myColors.randomColor()
    var score: Int = 0
    var time: Int = 60
    var pausedTime: Int = 0
    mutating func subtract(){
        self.time -= 1
    }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    mutating func buttonTapped(isYes: Bool) {
        if isYes && myColors.matches(color1: topText, color2: colorText){
            self.score += 10
        } else if isYes == false && myColors.matches(color1: topText, color2: colorText) == false{
            self.score += 10
        } else {
            self.score -= 10
        }
        topText = myColors.randomColor()
        bottomText = myColors.randomColor()
        colorText = myColors.randomForColorValue(color: topText)
    }
    
}


struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var gameState: GameState = GameState()
    @Binding var highScore: Int
    @State var pauseActive = false
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    var body: some View {
        NavigationLink(destination: PauseView(gameState: $gameState), isActive: $pauseActive) {
          Text("")
        }.hidden()
        VStack{
            HStack{
                // "Pause", time, score
                Button(action: {
                    gameState.pausedTime = gameState.time
                    pauseActive = true
                }, label: {
                    Text("||")
                        .font(.caption)
                        .frame(width: self.width / 10, height: self.width / 10)
                        .background(Color(.gray))
                        .foregroundColor(Color(.white))
                        .scaledToFill()
                }).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                Text("Time: \(self.gameState.time)")
                    .padding(2)
                    .background(Color(.gray))
                    .font(.caption)
                    .foregroundColor(Color(.white))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                    .onReceive(self.gameState.timer) { _ in
                        if self.gameState.time > 0 {
                            self.gameState.subtract()
                        } else {
                            if self.gameState.score >= highScore {
                                self.highScore = self.gameState.score
                            }
                            self.presentationMode.wrappedValue.dismiss()
                            // self.returnToMainMenu = true
                        }
                     }
                Text("Score: \(gameState.score)")
                    .padding(2)
                    .background(Color(.gray))
                    .font(.caption)
                    .foregroundColor(Color(.white))
                    .frame(minWidth: 0, maxWidth: 70, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            HStack{
                VStack{
                    //Text
                    Text("Does the meaning match the color?")
                        .foregroundColor(Color(.white))
                    //"Meaning"
                    Text("meaning")
                        .font(.caption)
                        .padding(.all)
                        .frame(width: self.width * 0.333)
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .foregroundColor(Color(.white))
                    //color
                    Text(gameState.topText.rawValue)
                        .font(.largeTitle)
                        .padding(.all)
                        .frame(width: self.width * 0.75)
                        .background(Color(.gray))
                        .cornerRadius(10)
                    //color
                    Text(gameState.bottomText.rawValue)
                        .font(.largeTitle)
                        .padding(.all)
                        .frame(width: self.width * 0.75)
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .foregroundColor(gameState.colorText.value())
                    //"text color"
                    Text("text color")
                        .font(.caption)
                        .padding(.all)
                        .frame(width: self.width * 0.333)
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .foregroundColor(Color(.white))
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            HStack{
                //"Yes", "No"
                Button(action: {self.gameState.buttonTapped(isYes: true)}, label: {
                    Text("Yes")
                        .font(.title)
                        .padding(.all)
                        .frame(width: self.width / 2 - 1)
                        .background(Color(.gray))
                        .foregroundColor(Color(.white))
                })
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                Button(action: {self.gameState.buttonTapped(isYes: false)}, label: {
                    Text("No")
                        .font(.title)
                        .padding(.all)
                        .frame(width: self.width / 2 - 1)
                        .background(Color(.gray))
                        .foregroundColor(Color(.white))
                })
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
        }
        .background(Color(.black))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


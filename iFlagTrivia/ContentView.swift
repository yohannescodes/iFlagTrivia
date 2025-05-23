//
//  ContentView.swift
//  iFlagTrivia
//
//  Created by Yohannes Haile on 1/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var viewModel = iFlagTriviaViewModel()
    @State var score: Int = 0
    @State var flagOptions: [iFlag] = []
    @State var flagStaged: iFlag = iFlag(name: "", flag: "")
    @State var isGameReady: Bool = false
    @State var isGameOver: Bool = false
    @State var highScore: Int = 0
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    themeManager.toggleTheme()
                }) {
                    Image(systemName: themeIconName())
                        .foregroundColor(Color("ButtonTextColor")) // Use custom color
                        .padding()
                        .background(Color("ButtonBackgroundColor")) // Use custom color
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }

            if isGameReady {
                VStack(spacing: 40) {
                    // HStack for scores remains, theme button is above this
                    VStack {
                        HStack{
                            Spacer()
                            Text("High Score: \(highScore)")
                                .padding()
                                .foregroundColor(Color("TextColor")) // Use custom color
                                .background(Color("BackgroundColor")) // Use custom color
                            Spacer()
                            Text("Score: \(score)")
                                .padding()
                                .foregroundColor(Color("TextColor")) // Use custom color
                                .background(Color("BackgroundColor")) // Use custom color
                            Spacer()
                        }
                        
                        Text("Guess which country's flag this is")
                            .foregroundColor(Color("TextColor")) // Use custom color
                            .fontWeight(.ultraLight)
                            .font(.system(size: 22))
                        Text(flagStaged.flag)
                            .foregroundColor(Color("TextColor")) // Use custom color
                            .font(.system(size: 100))
                            .fontWeight(.heavy)
                    }

                }
                VStack {
                    HStack {
                        Spacer()
                        Button(flagOptions[0].name) {
                            handleAnswer(selectedOption: flagOptions[0])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(Color("ButtonBackgroundColor")) // Use custom color
                        .foregroundColor(Color("ButtonTextColor")) // Use custom color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        Button(flagOptions[1].name) {
                            handleAnswer(selectedOption: flagOptions[1])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(Color("ButtonBackgroundColor")) // Use custom color
                        .foregroundColor(Color("ButtonTextColor")) // Use custom color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(flagOptions[2].name) {
                            handleAnswer(selectedOption: flagOptions[2])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(Color("ButtonBackgroundColor")) // Use custom color
                        .foregroundColor(Color("ButtonTextColor")) // Use custom color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        Button(flagOptions[3].name) {
                            handleAnswer(selectedOption: flagOptions[3])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(Color("ButtonBackgroundColor")) // Use custom color
                        .foregroundColor(Color("ButtonTextColor")) // Use custom color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                    }
                }
            }else {
                Text("Loading...")
                    .font(.title)
                    .foregroundColor(Color("TextColor")) // Use custom color
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all)) // Use custom background color
        .alert("Game Over :( You scored \(score)!", isPresented: $isGameOver){
            
            Button("Ok", role: .cancel){
                setHighScore(score: score)
                resetGame()
            }
        }
        .padding()
        .onAppear(perform: startNewGame)
    }

    private func themeIconName() -> String {
        switch themeManager.currentTheme {
        case .light:
            return "moon.fill"
        case .dark:
            return "sun.max.fill"
        case .system:
            return "gearshape.fill"
        }
    }
    
    func handleAnswer(selectedOption: iFlag) {
        let scored = viewModel.evaluateAnswer(correctAnswer: flagStaged, userAnswer: selectedOption.flag)
        if scored {
            score += 10
            startNewGame()
        }else{
            isGameOver = true
        }
        
    }

    func startNewGame() {
        highScore = UserDefaults().integer(forKey: "HS")
        flagOptions = viewModel.generateQuestion()
        if !flagOptions.isEmpty {
            flagStaged = flagOptions[Int.random(in: 0...3)]
            isGameReady = true
        }
    }
    func resetGame(){
        score = 0
        isGameOver = false
        startNewGame()
    }
    
    func setHighScore(score: Int){
        if score > UserDefaults().integer(forKey: "HS") {
            UserDefaults().set(score, forKey: "HS")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}

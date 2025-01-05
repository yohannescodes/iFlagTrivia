//
//  ContentView.swift
//  iFlagTrivia
//
//  Created by Yohannes Haile on 1/4/25.
//

import SwiftUI

struct ContentView: View {
    var viewModel = iFlagTriviaViewModel()
    @State var score: Int = 0
    @State var flagOptions: [iFlag] = []
    @State var flagStaged: iFlag = iFlag(name: "", flag: "")
    @State var isGameReady: Bool = false
    @State var isGameOver: Bool = false
    @State var highScore: Int = 0
    var body: some View {
        
        VStack {
            if isGameReady {
                VStack(spacing: 40) {
                    HStack{
                        Spacer()
                        
                    }
                    VStack {
                        HStack{
                            Spacer()
                            Text("High Score: \(highScore)")
                                .padding()
                                .foregroundColor(.white)
                                .background(.black)
                            Spacer()
                            Text("Score: \(score)")
                                .padding()
                            Spacer()
                        }
                        
                        Text("Guess which country's flag this is")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 22))
                        Text(flagStaged.flag)
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
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        Button(flagOptions[1].name) {
                            handleAnswer(selectedOption: flagOptions[1])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
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
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        Button(flagOptions[3].name) {
                            handleAnswer(selectedOption: flagOptions[3])
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                    }
                }
            }else {
                Text("Loading...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }.alert("Game Over :( You scored \(score)!", isPresented: $isGameOver){
            
            Button("Ok", role: .cancel){
                setHighScore(score: score)
                resetGame()
            }
        }
        .padding()
        .onAppear(perform: startNewGame)
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
}

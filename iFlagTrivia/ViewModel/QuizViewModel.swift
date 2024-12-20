//
//  QuizViewModel.swift
//  iFlagTrivia
//
//  Created by Yohannes Haile on 12/20/24.
//

import Foundation
import Combine

class QuizViewModel {
    @Published private(set) var questionText: String = ""
    @Published private(set) var options: [String] = []
    @Published private(set) var correctAnswer: String = ""
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadQuestion()
    }

    func loadQuestion() {
        let allFlags = Country.all.shuffled()
        let correct = allFlags[0]
        correctAnswer = correct.name

        questionText = "Which country's flag is this? \(correct.flag)"
        options = allFlags.prefix(4).map { $0.name }.shuffled()
    }

    func isAnswerCorrect(_ answer: String) -> Bool {
        return answer == correctAnswer
    }
}

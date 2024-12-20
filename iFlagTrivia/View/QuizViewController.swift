//
//  QuizViewController.swift
//  iFlagTrivia
//
//  Created by Yohannes Haile on 12/20/24.
//

import UIKit
import Combine

class QuizViewController: UIViewController {
    private var viewModel = QuizViewModel()
    private var cancellables = Set<AnyCancellable>()

    private var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "iTrivia"
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.addSubview(questionLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30)
        ])

        for _ in 0..<4 {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(answerTapped), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            buttons.append(button)
            buttonStack.addArrangedSubview(button)
        }
    }

    private func bindViewModel() {
        viewModel.$questionText
            .receive(on: RunLoop.main)
            .sink { [weak self] question in
                self?.questionLabel.text = question
            }
            .store(in: &cancellables)

        viewModel.$options
            .receive(on: RunLoop.main)
            .sink { [weak self] options in
                guard let self = self else { return }
                for (index, button) in self.buttons.enumerated() {
                    if index < options.count {
                        button.setTitle(options[index], for: .normal)
                        button.isHidden = false
                    } else {
                        button.isHidden = true
                    }
                }
            }
            .store(in: &cancellables)
    }


    @objc private func answerTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        let isCorrect = viewModel.isAnswerCorrect(title)
        let alert = UIAlertController(
            title: isCorrect ? "Correct!" : "Wrong!",
            message: isCorrect ? "You got it right!" : "The correct answer was \(viewModel.correctAnswer).",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { [weak self] _ in
            self?.viewModel.loadQuestion()
        }))

        present(alert, animated: true, completion: nil)
    }
}

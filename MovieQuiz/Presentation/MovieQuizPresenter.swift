//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим Казанцев on 22.06.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    internal var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    weak var viewController: MovieQuizViewController?
    
    let questionsAmount: Int = 10
    
    
     internal func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {return}
         
        let givenAnswer = true
         
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
         
    }
    
     internal func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
         
         viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    
     func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

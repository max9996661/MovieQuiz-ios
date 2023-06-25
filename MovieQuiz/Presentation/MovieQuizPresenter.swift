//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим Казанцев on 22.06.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticService!
    private var currentQuestionIndex: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    internal var currentQuestion: QuizQuestion?
    internal var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QustionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    internal func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    internal func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    internal func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
                    self?.viewController?.show(quiz: viewModel)
                }
    }
    
    internal func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    internal func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    internal func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    internal func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    internal func convert(model: QuizQuestion) -> QuizStepViewModel {
       QuizStepViewModel(
           image: UIImage(data: model.image) ?? UIImage(),
           question: model.text,
           questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
   }
    
     internal func yesButtonClicked() {
         didAnswer(isYes: true)
    }
    
     internal func noButtonClicked() {
         didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool){
       didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
           guard let self = self else {return}
           self.proceedToNextQuestionOrResults()
       }
   }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    internal func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = correctAnswers == self.questionsAmount ?
                        "Поздравляем, вы ответили на 10 из 10!" :
                        "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                        
                        let viewModel = QuizResultsViewModel(
                            title: "Этот раунд окончен!",
                            text: text,
                            buttonText: "Сыграть ещё раз")
                            viewController?.showFinalResults(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
        
    internal func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
               + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [
        currentGameResultLine,totalPlaysCountLine,bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }

}

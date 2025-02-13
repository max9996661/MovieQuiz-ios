//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Казанцев on 17.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // успешная загрузка
    func didFailToLoadData(with error: Error)
}

//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Максим Казанцев on 27.05.2023.
//

import Foundation


struct BestGame: Codable {
    // Колл-во правильных ответов
    var correct: Int
    // Колл-во вопросов квиза
    var total : Int
    // Дату завершения раунда
    var date: Date
    
}

extension BestGame : Comparable {
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
    
}

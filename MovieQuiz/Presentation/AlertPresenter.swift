//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим Казанцев on 20.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func show(with model: AlertModel)
}

final class AlertPresenter : AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func show(with model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.buttoAction()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
    
}

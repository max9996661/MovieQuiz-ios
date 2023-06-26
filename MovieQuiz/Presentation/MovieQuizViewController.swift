import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

// MARK: - UI element
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(presenter: MovieQuizPresenter){
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
        
// MARK: functions
    internal func show(quiz result: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = result.image
        textLabel.text = result.question
        counterLabel.text = result.questionNumber
    }
    
     func showFinalResults(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
     func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
 // MARK: ACTION
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
// MARK: Indicator Action
    
     func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
     func hideLoadingIndicator() {
          activityIndicator.isHidden = true
      }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)

        let action = UIAlertAction(title: "Попробовать ещё раз",
                    style: .default) { [weak self] _ in
                        guard let self = self else { return }

        self.presenter.restartGame()
        }
        alert.addAction(action)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        
    }
}


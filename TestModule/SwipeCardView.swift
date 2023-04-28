//
//  CardsContainerView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 28.03.2023.
//

import UIKit

class SwipeCardView: UIView {
    
    weak var delegate: SwipeCardsDelegate?
    
    var dataSourse: Word? {
        didSet {
            wordLabel.text = dataSourse?.name
            
        }
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(didPan))
        return pan
    }()

    private var frontView = CardView()
    private let wordLabel = WordLabel()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    @objc private func didPan() {
        guard let card = panGesture.view as? SwipeCardView else { return }
        let point = panGesture.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2,
                                              y: self.frame.height / 2)
        
        card.center = CGPoint(x: self.center.x + point.x,
                              y: self.center.y + point.y)
        
        switch panGesture.state {
        case .ended:
            if card.center.x > 400 {
                swipe(card: card,
                      point: point,
                      centerOfParentContainer: centerOfParentContainer) //swipe right
                
                updateWordStatus()
                delegate?.countRightWrongAnswers(isRight: true)
                
                return
            } else if card.center.x < -65 {
                swipe(card: card,
                      point: point,
                      centerOfParentContainer: centerOfParentContainer) //swipe left
            
                delegate?.countRightWrongAnswers(isRight: false)
                
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2,
                                      y: self.frame.height / 2)
            }
            
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    private func swipe(card: SwipeCardView,
                       point: CGPoint,
                       centerOfParentContainer: CGPoint) {
        
        delegate?.swipeDidEnd(on: card)
        
        card.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
        
        UIView.animate(withDuration: 0.2) {
            card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200,
                                  y: centerOfParentContainer.y + point.y + 75)
            card.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    private func updateWordStatus() {
        guard let word = dataSourse else { return }
        delegate?.updateWordStatus(word: word, isLearnt: true)
    }
}

//MARK: - Set UI
extension SwipeCardView {
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(frontView)
        frontView.addSubview(wordLabel)
        
        frontView.pinEdgesToSuperView()
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: frontView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: frontView.centerYAnchor)
        ])
    }
}

//
//  CardsContainerView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 28.03.2023.
//

import UIKit

class CardView: UIView {
    
    var dataSourse: Word? {
        didSet {
            wordLabel.text = dataSourse?.name
            translationLabel.text = dataSourse?.translation
        }
    }
    
    weak var delegate: SwipeCardsDelegate?
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        return pan
    }()
    
    private lazy var frontView: UIView = {
        let view = UIView()
        view.configureBaseView()
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.configureBaseView()
        return view
    }()
    
    private let wordLabel = WordLabel()
    
    private let translationLabel = TranslationLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didPan() {
        guard let card = panGesture.view as? CardView else { return }
        let point = panGesture.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2,
                                              y: self.frame.height / 2)
        
        card.center = CGPoint(x: self.center.x + point.x,
                              y: self.center.y + point.y)
        
        switch panGesture.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)

                swipe(card: card,
                      point: point,
                      centerOfParentContainer: centerOfParentContainer) //swipe right
                
                updateWordStatus()
                
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                
                swipe(card: card,
                      point: point,
                      centerOfParentContainer: centerOfParentContainer) //swipe left
            
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
    
    private func swipe(card: CardView, point: CGPoint, centerOfParentContainer: CGPoint) {
        card.center = CGPoint(x: self.center.x + point.x,
                              y: self.center.y + point.y)
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
//        StorageManager.shared.updateStatus(word, isLearnt: true)
    }
}

//MARK: - Set UI
extension CardView {
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(frontView)
        addSubview(backView)
        frontView.addSubview(wordLabel)
        backView.addSubview(translationLabel)
        
        NSLayoutConstraint.activate([
            frontView.topAnchor.constraint(equalTo: topAnchor),
            frontView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frontView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            translationLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            translationLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: frontView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: frontView.centerYAnchor)
        ])
    }
}

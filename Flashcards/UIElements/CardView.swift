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
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200,
                                          y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200,
                                          y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
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
}

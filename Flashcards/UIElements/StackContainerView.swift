//
//  ContainerView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 30.03.2023.
//

import UIKit

protocol SwipeCardsDelegate: AnyObject {
    func swipeDidEnd(on view: CardView)
    func updateWordStatus(word: Word, isLearnt: Bool)
}

class StackContainerView: UIView {
    
    private var numberOfCardsToShow = 0
    private var numberOfVisibleCards = 2
    private var cardViews: [CardView] = []
    private var remainingCards = 0
    
    private let horizontalInset: CGFloat = 10.0
    private let verticalInset: CGFloat = 10.0
    
    private var visibleCards: [CardView] {
        subviews as? [CardView] ?? []
    }
    
    weak var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = dataSource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        
        for index in 0..<min(numberOfCardsToShow, numberOfVisibleCards) {
            addCardView(cardView: dataSource.showCard(at: index), atIndex: index)
        }
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func addCardFrame(index: Int, cardView: CardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = (CGFloat(index) * self.verticalInset)
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
}

//MARK: - SwipeCardsDelegate
extension StackContainerView: SwipeCardsDelegate {
    func swipeDidEnd(on view: CardView) {
        guard let dataSource = dataSource else { return }
        view.removeFromSuperview()
        
        if remainingCards > 0 {
            let newIndex = dataSource.numberOfCardsToShow() - remainingCards
            addCardView(cardView: dataSource.showCard(at: newIndex), atIndex: 1)
            
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        }
        dataSource.countPreviousWords()
    }
    
    func updateWordStatus(word: Word, isLearnt: Bool) {
        dataSource?.update(word: word, isLearnt: isLearnt)
    }
}

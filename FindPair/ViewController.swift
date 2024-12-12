//
//  ViewController.swift
//  FindPair
//
//  Created by Aldongarov Nuraskhan on 12.12.2024.
//

import UIKit

import UIKit

class Controller: UIViewController {
    
    private var cards: [Card] = []
    private var selectedCards: [CardView] = []
    private let gridContainer = UIView()
    private let categories = ["Animals", "Fruits", "Vegetables"]
    private var timer: Timer?
    private var timeRemaining: Int = 60
    private let timerLabel = UILabel()
    private let startButton = UIButton(type: .system)
    
    private var total = 16
    private var score = 0
    
    
    private var backButton = UIButton()
    private var categoryDropdownButton = UIButton()
    private var scoreLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupView()
    }
    
    private func setupGame() {
        let category = categories[0]
        let words = ["dog_image", "cat_image", "lion_image", "tiger_image","panda_image", "llama_image", "hippo_image", "monkey_image"]
        let images = ["dog_image", "cat_image", "lion_image", "tiger_image","panda_image", "llama_image", "hippo_image", "monkey_image"]
        
        for i in 0..<8 {
            if let a = UIImage(named: words[i]), let b = UIImage(named: images[i]) {
                cards.append(Card(id: i, content: a, isImage: true))
                cards.append(Card(id: i, content: b, isImage: true))
            }
        }
        
        cards.shuffle()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupTopBar()
        
        timerLabel.text = "Time: 60"
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(timerLabel)
                
        view.addSubview(gridContainer)
                
        
        for card in cards {
            let cardView = CardView()
            cardView.card = card
            cardView.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)
            cardView.isUserInteractionEnabled = false
            gridContainer.addSubview(cardView)
        }
        
        startButton.setTitle("Start Game", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startButton)
        setupConstraints()
    }
    
    private func setupTopBar() {
        backButton.setTitle("Break", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .systemBlue
        backButton.layer.cornerRadius = 8
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        categoryDropdownButton.setTitle("Categories", for: .normal)
        categoryDropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        categoryDropdownButton.setTitleColor(.white, for: .normal)
        categoryDropdownButton.backgroundColor = .systemBlue
        categoryDropdownButton.layer.cornerRadius = 8
        categoryDropdownButton.addTarget(self, action: #selector(categoryDropdownTapped), for: .touchUpInside)
        view.addSubview(categoryDropdownButton)
        
        scoreLabel.text = "Moves: \(score)"
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        scoreLabel.textColor = .black
        view.addSubview(scoreLabel)
    }
    @objc private func backButtonTapped() {
        timer?.invalidate()
        timer = nil
        total = 16
        score = 0
        for subview in gridContainer.subviews {
            if let cardView = subview as? CardView {
                cardView.isUserInteractionEnabled = false
            }
        }
        startButton.isHidden = false
        cards.shuffle()
    }
    @objc private func categoryDropdownTapped() {
        print("Category dropdown tapped")
    }
    private func setupConstraints() {
        // Back Button
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        // Category Dropdown Button
        categoryDropdownButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        // Score Label
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        // Timer Label
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        // Grid Container
        gridContainer.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(gridContainer.snp.width)
        }
        
        // Layout Card Views inside Grid Container
        let cardSize = (UIScreen.main.bounds.width - 60) / 4
        for (index, cardView) in gridContainer.subviews.enumerated() {
            guard let card = cardView as? CardView else { continue }
            let row = index / 4
            let col = index % 4
            
            card.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(CGFloat(row) * (cardSize + 10))
                make.leading.equalToSuperview().offset(CGFloat(col) * (cardSize + 10))
                make.width.height.equalTo(cardSize)
            }
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func startGame() {
        startButton.isHidden = true
        resetGame()
        startTimer()
        for subview in gridContainer.subviews {
            if let cardView = subview as? CardView {
                cardView.isUserInteractionEnabled = true
            }
        }
        cards.shuffle()
    }
    private func resetGame() {
        for subview in gridContainer.subviews {
            if let cardView = subview as? CardView {
                cardView.isRevealed = false
                cardView.isUserInteractionEnabled = true
            }
        }
        selectedCards.removeAll()
    }
    
    private func startTimer() {
        timeRemaining = 60
        timerLabel.text = "Time: \(timeRemaining)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        timeRemaining -= 1
        scoreLabel.text = "Moves: \(score)"
        timerLabel.text = "Time: \(timeRemaining)"
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            timer = nil
            endGame()
        }
        if total == 0 {
            timer?.invalidate()
            timer = nil
            winGame()
        }
    }
    
    private func endGame() {
        for subview in gridContainer.subviews {
            if let cardView = subview as? CardView {
                cardView.isUserInteractionEnabled = false
            }
        }
        
        let alert = UIAlertController(title: "Game Over", message: "Time is up!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.startButton.isHidden = false
        }))
        present(alert, animated: true)
        cards.shuffle()
    }
    private func winGame(){
        for subview in gridContainer.subviews {
            if let cardView = subview as? CardView {
                cardView.isUserInteractionEnabled = false
            }
        }
        total = 16
        let alert = UIAlertController(title: "Congratz!", message: "You win!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.startButton.isHidden = false
        }))
        present(alert, animated: true)
        cards.shuffle()
    }
    
    
    @objc private func cardTapped(_ sender: CardView) {
        guard !sender.isRevealed else { return }
        sender.isRevealed = true
        selectedCards.append(sender)
        
        if selectedCards.count == 2 {
            checkMatch()
        }
    }
    
    private func checkMatch() {
        guard selectedCards.count == 2 else { return }
        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]
        
        if firstCard.card?.id == secondCard.card?.id {
            // Match found
            total = total - 2
            firstCard.isUserInteractionEnabled = false
            secondCard.isUserInteractionEnabled = false
        } else {
            // No match
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstCard.isRevealed = false
                secondCard.isRevealed = false
            }
        }
        score = score + 1
        selectedCards.removeAll()
    }
}

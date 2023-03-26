//
//  MainViewController.swift
//  DeckOfCards
//
//  Created by Alexey Manokhin on 25.03.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var resultsLabel: UILabel!
    
    @IBOutlet var firstCardImageView: UIImageView!
    @IBOutlet var secondCardImageView: UIImageView!
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var showCardsButton: UIButton!
    @IBOutlet var restartButton: UIButton!
    
    @IBOutlet var cardsStackView: UIStackView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var tappedCount = 0 {
        didSet {
            if tappedCount == 10 {
                resultsLabel.textColor = .red
                resultsLabel.text = "ВЫ ПРОИГРАЛИ =(\nНе расстраивайтесь, следующий раз обязательно повезет!"
                showCardsButton.isHidden = true
                progressBar.isHidden = true
                restartButton.isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = cardsStackView.center
        activityIndicator.stopAnimating()
        resultsLabel.text = """
Карта, содержащая число, приносит количество очков, равное номиналу. Каждая карта с картинкой или туз, приносит 10 очков.\n
Цель:\nНабрать 20 очков за 10 ходов
"""
    }
    @IBAction func showCardsButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        activityIndicator.startAnimating()
        resultsLabel.isHidden = false
        firstCardImageView.isHidden = false
        secondCardImageView.isHidden = false
        guard let url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=2") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            
            let decoder = JSONDecoder()
            
            do {
                let card = try decoder.decode(ResponseCard.self, from: data)
                
                let firstCardImageData = try! Data(contentsOf: card.cards[0].image)
                let secondCardImageData = try! Data(contentsOf: card.cards[1].image)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    sender.setTitle("Раздать карты", for: .normal)
                    self.resultsLabel.text = "Вы набрали " + String((Int(card.cards[0].value) ?? 10) + (Int(card.cards[1].value) ?? 10)) + " очков"
                    
                    if self.resultsLabel.text == "Вы набрали 20 очков" {
                        self.progressBar.isHidden = true
                        self.resultsLabel.textColor = .systemGreen
                        self.resultsLabel.text! += "\nУра! Победа!\nКоличество ходов: \(Int(self.progressBar.progress * 10 + 1))"
                        sender.isHidden = true
                        self.restartButton.isHidden = false
                    }
                    
                    sender.isHidden = false
                    self.firstCardImageView.image = UIImage(data: firstCardImageData)
                    self.secondCardImageView.image = UIImage(data: secondCardImageData)
                    self.progressBar.progress += 0.1
                    self.tappedCount += 1
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    @IBAction func restartButtonTapped() {
        
        tappedCount = 0
        showCardsButton.isHidden = false
        progressBar.progress = 0
        resultsLabel.textColor = .black
        resultsLabel.isHidden = true
        restartButton.isHidden = true
        progressBar.isHidden = false
        firstCardImageView.isHidden = true
        secondCardImageView.isHidden = true
    }
}

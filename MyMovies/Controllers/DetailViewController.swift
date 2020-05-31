//
//  DetailViewController.swift
//  MyMovies
//
//  Created by Кирилл on 31.05.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

	
	@IBOutlet weak var trailingPosterConstraint: NSLayoutConstraint!
	@IBOutlet weak var poster: UIImageView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var opinionTextField: UITextField!
	@IBOutlet weak var yearLabel: UILabel!
	@IBOutlet var ratingButtons: [UIButton]!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var seeReviews: UIButton!
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		trailingPosterConstraint.constant = self.view.frame.size.width / 2
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		titleTextField.delegate = self
		setupRatingStars()
		yearLabel.isHidden = true
		seeReviews.isHidden = true
        // Do any additional setup after loading the view.
    }
	
	@IBAction func seeReviewsTapped(_ sender: UIButton) {
		
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if !textField.text!.isEmpty {
			guessTheMovie()
			saveButton.isEnabled = true
		} else {
			saveButton.isEnabled = false
		}
	}
	
	func saveMovie() {
		
	}
	
	func guessTheMovie() {
		
		let movieName = parseMovieName(titleTextField.text!)
		let urlString = "https://imdb8.p.rapidapi.com/title/find?rapidapi-key=154be36594msh690f2165b20d664p1c04fcjsnbae1791dc641&q=" + movieName
		guard let url = URL(string: urlString) else { return }
		
		var title = ""
		var year = 0
		var image: UIImage?
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			if error == nil && data != nil {
				do {
					let decoder = JSONDecoder()
					let foundInfomarion = try decoder.decode(FoundInformation.self, from: data!)
					guard let movies = foundInfomarion.results else { return }
					let movie = movies[0]
					if movie.title != nil, movie.year != nil {
						title = movie.title!
						year = movie.year!
					}
					guard let urlImageString = movie.image?.url else { return }
					guard let imageURL = URL(string: urlImageString) else { return }
					
					URLSession.shared.dataTask(with: imageURL) { (imageData, imageResponse, imageError) in
						if imageError == nil && imageData != nil {
							DispatchQueue.main.async {
								image = UIImage(data: imageData!)
								self.presentGuessingAlertController(title: title, year: year, image: image!)
							}
						} else {
							print("Error loading image from JSON")
						}
					}.resume()
				} catch {
					print("Error in JSON parsing")
				}
			}
		}.resume()
		
		
	}
	
	func presentGuessingAlertController(title: String, year: Int, image: UIImage) {
		let guessingMessage = "\(title) released in \(year)?"
		let alertController = UIAlertController(title: "Did you mean...", message: guessingMessage, preferredStyle: .alert)
		
		let yesAction = UIAlertAction(title: "Yes!", style: .default) { _ in
			self.yearLabel.isHidden.toggle()
			self.seeReviews.isHidden.toggle()
			self.yearLabel.text = "\(year)"
			self.poster.image = image
		}
		let noAction = UIAlertAction(title: "No", style: .destructive) { _ in
			self.yearLabel.isHidden.toggle()
			self.seeReviews.isHidden.toggle()
		}
		
		alertController.addAction(yesAction)
		alertController.addAction(noAction)
		
		present(alertController, animated: true)
	}
	
	func parseMovieName(_ movie: String) -> String {
		var parsedName = movie.replacingOccurrences(of: "'", with: "%27")
		parsedName = movie.replacingOccurrences(of: " ", with: "%20")
		return parsedName
	}
	
	func setupRatingStars() {
		
		
		for button in ratingButtons {
			button.backgroundColor = .clear
		}
		
	}
	
	

}

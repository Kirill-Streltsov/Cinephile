//
//  DetailViewController.swift
//  MyMovies
//
//  Created by Кирилл on 31.05.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	enum Mode {
		case edit
		case add
	}
	
	@IBOutlet weak var trailingPosterConstraint: NSLayoutConstraint!
	@IBOutlet weak var poster: UIImageView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var opinionTextView: UITextView!
	@IBOutlet weak var yearLabel: UILabel!
	@IBOutlet var ratingButtons: [UIButton]!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var seeReviews: UIButton!
	@IBOutlet weak var addYourPosterLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var durationLabel: UILabel!
	
	var opinion = ""
	var id = ""
	var rating = 0.0
	var duration: Int16 = 0
	var titleName = ""
	var titleNameIfEdit = ""
	var usersRating: Int16 = 0
	var year: Int16 = 0
	var image = UIImage(named: "movieCamera")
	var wasFoundInTheWeb = false
	var mode: Mode = .edit
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		trailingPosterConstraint.constant = self.view.frame.size.width / 2
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
		titleNameIfEdit = titleName
		titleTextField.delegate = self
		opinionTextView.delegate = self
		activityIndicator.isHidden = true
		setupRatingStars()
		toggleLabelAppearance(show: wasFoundInTheWeb)
		switch mode {
		case .edit:
			opinionTextView.text = opinion
			titleTextField.text = titleName
			yearLabel.text = "Year: \(year)"
			ratingLabel.text = "Rating: \(rating)/5"
			durationLabel.text = "Duration: \(duration)m"
			poster.image = image
			saveButton.isEnabled = true
		case .add:
			opinionTextView.text = "Here you can write your thoughts about the movie..."
			opinionTextView.textColor = UIColor.lightGray
			break
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if mode == .add {
			titleTextField.becomeFirstResponder()
		}
	}
	
	@IBAction func seeReviewsTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func addPosterTapped(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.allowsEditing = false
		
		present(imagePickerController, animated: true) {
			self.addYourPosterLabel.isHidden = true
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			poster.contentMode = .scaleAspectFit
			poster.image = image
		}
		dismiss(animated: true)
	}
	
	@IBAction func rateButtonTapped(_ sender: UIButton) {
		
		let indexOfTappedButton = ratingButtons.firstIndex(of: sender)!
		if sender.currentImage == UIImage(named: "emptyStar") {
			for index in 0...indexOfTappedButton {
				ratingButtons[index].setImage(UIImage(named: "filledStar"), for: .normal)
			}
			usersRating = Int16(indexOfTappedButton + 1)
		} else if (sender.currentImage == UIImage(named: "filledStar") && indexOfTappedButton == ratingButtons.count - 1) || (indexOfTappedButton != ratingButtons.count - 1 && ratingButtons[indexOfTappedButton + 1].currentImage == UIImage(named: "emptyStar")){
			for index in 0...indexOfTappedButton {
				ratingButtons[index].setImage(UIImage(named: "emptyStar"), for: .normal)
			}
			usersRating = 0
		} else {
			for index in 0..<ratingButtons.count {
				if index <= indexOfTappedButton {
					ratingButtons[index].setImage(UIImage(named: "filledStar"), for: .normal)
				} else {
					ratingButtons[index].setImage(UIImage(named: "emptyStar"), for: .normal)
				}
			}
			usersRating = Int16(indexOfTappedButton + 1)
		}
	}
	
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
		
		var data: Data?
		let dataDefaultPoster = UIImage(named: "movieCamera")?.pngData()
		
		if poster.image?.pngData() != dataDefaultPoster {
			print("it was not movie camera")
			data = poster.image?.pngData()
		}
		
		switch mode {
		case .add:
			//TODO: Add some code in this case
			//			if isAlreadyInCollection(title: titleName) {
			//
			//			}
			let movie = NSManagedObject(entity: entity!, insertInto: context)
			
			movie.setValue(data, forKey: "poster")
			
			if opinionTextView.text != "" {
				movie.setValue(opinionTextView.text, forKey: "opinion")
			}
			
			movie.setValue(titleTextField.text!, forKey: "title")
			movie.setValue(Date(), forKey: "date")
			movie.setValue(usersRating, forKey: "usersRating")
			
			if wasFoundInTheWeb {
				movie.setValue(rating, forKey: "rating")
				movie.setValue(duration, forKey: "runningTimeInMinutes")
				movie.setValue(year, forKey: "year")
			}
			movie.setValue(wasFoundInTheWeb, forKey: "wasFound")
		case .edit:
			
			let predicate = NSPredicate(format: "title == %@", titleNameIfEdit)
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
			request.predicate = predicate
			
			do {
				let result = try context.fetch(request) as? [NSManagedObject]
				let movie = result?.first
				movie?.setValue(titleTextField.text, forKey: "title")
				movie?.setValue(year, forKey: "year")
				movie?.setValue(opinionTextView.text, forKey: "opinion")
				movie?.setValue(data, forKey: "poster")
				movie?.setValue(usersRating, forKey: "usersRating")
				movie?.setValue(wasFoundInTheWeb, forKey: "wasFound")
				
			} catch {
				print(error)
			}
		}
		
		do {
			try context.save()
		} catch {
			print("Failed saving")
		}
		navigationController?.popViewController(animated: true)
		dismiss(animated: true)
	}
	
	func guessTheMovie() {
		
		let movieName = parseMovieName(titleTextField.text!)
		let urlString = "https://imdb8.p.rapidapi.com/title/find?rapidapi-key=6eaa56b8c1msh4b4f2e1289ef209p1cb2e1jsnb9fb1dccbe1d&q=" + movieName
		guard let url = URL(string: urlString) else { return }
		
		var image: UIImage?
		
		self.poster.image = .none
		self.addYourPosterLabel.isHidden = true
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		
		let session: URLSession = {
			let configuration = URLSessionConfiguration.default
			configuration.timeoutIntervalForRequest = 10.0 // seconds
			return URLSession(configuration: .default)
		}()
		
		// MARK: Movie request (all information)
		session.dataTask(with: url) { (data, response, error) in
			
			if error != nil {
				self.presentUnsuccessfulAlert()
			}
			
			if error == nil && data != nil {
				
				do {
					
					let decoder = JSONDecoder()
					let foundInfomarion = try decoder.decode(FoundInformation.self, from: data!)
					guard let movies = foundInfomarion.results else { return }
					let movie = movies[0]
					if movie.title != nil, movie.year != nil, movie.id != nil, movie.runningTimeInMinutes != nil {
						self.titleName = movie.title!
						self.year = movie.year!
						self.id = movie.id!.replacingOccurrences(of: "/title/", with: "")
						self.duration = movie.runningTimeInMinutes!
					}
					
					if let ratingURL = URL(string: "https://imdb8.p.rapidapi.com/title/get-ratings?tconst=tt0088247/&rapidapi-key=6eaa56b8c1msh4b4f2e1289ef209p1cb2e1jsnb9fb1dccbe1d".replacingOccurrences(of: "tt0088247", with: self.id)) {
						// MARK: Requesting movie's rating
						session.dataTask(with: ratingURL) { (ratingData, ratingResponse, ratingError) in
							
							if ratingError != nil {
								self.presentUnsuccessfulAlert()
							}
							
							if ratingError == nil && ratingData != nil {
								
								do {
									let decoderRating = JSONDecoder()
									let foundInformationRating = try decoderRating.decode(FoundInformation.self, from: ratingData!)
									if foundInformationRating.rating != nil {
										self.rating = foundInformationRating.rating! / 2
									}
									
									guard let urlImageString = movie.image?.url else { return }
									guard let imageURL = URL(string: urlImageString) else { return }
									
									// MARK: Requesting movie's image
									session.dataTask(with: imageURL) { (imageData, imageResponse, imageError) in
										
										if imageError != nil {
											self.presentUnsuccessfulAlert()
										}
										
										if imageError == nil && imageData != nil {
											DispatchQueue.main.async {
												image = UIImage(data: imageData!)
												self.activityIndicator.stopAnimating()
												self.presentGuessingAlertController(title: self.titleName, year: self.year, image: image!, rating: self.rating, duration: self.duration)
											}
										} else {
											self.presentUnsuccessfulAlert()
										}
									}.resume()
									
								} catch {
									self.presentUnsuccessfulAlert()
								}
								
							} else {
								self.presentUnsuccessfulAlert()
							}
						}.resume()
					}
					
				} catch {
					self.presentUnsuccessfulAlert()
				}
			}
		}.resume()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if opinionTextView.text.isEmpty {
			opinionTextView.text = "Here you can write your thoughts about the movie..."
			opinionTextView.textColor = UIColor.lightGray
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if opinionTextView.textColor == UIColor.lightGray {
			opinionTextView.text = nil
			opinionTextView.textColor = UIColor.black
		}
		moveTextView(opinionTextView, moveDistance: -150, up: true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		titleTextField.resignFirstResponder()
		if titleTextField.text != "" {
			if titleName != titleTextField.text! {
				saveButton.isEnabled = true
				titleName = titleTextField.text!
			}
		} else if titleTextField.text == "" {
			saveButton.isEnabled = false
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if titleTextField.text != "" {
			guessTheMovie()
			self.view.endEditing(true)
			return false
		}
		return true
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			opinionTextView.resignFirstResponder()
			moveTextView(opinionTextView, moveDistance: -150, up: false)
			return false
		}
		return true
	}
	
	@objc private func textFieldChanged() {
		if titleTextField.text!.isEmpty {
			saveButton.isEnabled = false
		} else {
			saveButton.isEnabled = true
		}
	}
	
	func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
		let moveDuration = 0.25
		let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
		
		UIView.beginAnimations("animateTextView", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(moveDuration)
		self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
		UIView.commitAnimations()
	}
	
	func presentGuessingAlertController(title: String, year: Int16, image: UIImage, rating: Double, duration: Int16) {
		if keyboardIsActive() {
			moveTextView(opinionTextView, moveDistance: -150, up: false)
			opinionTextView.resignFirstResponder()
		}
		let guessingMessage = "\(title) released in \(year)?"
		let alertController = UIAlertController(title: "Did you mean...", message: guessingMessage, preferredStyle: .alert)
		
		let yesAction = UIAlertAction(title: "Yes!", style: .default) { _ in
			
			self.wasFoundInTheWeb = true
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.toggleLabelAppearance(show: true)
			self.ratingLabel.text = "Rating: \(rating)/5"
			self.yearLabel.text = "Year: \(year)"
			self.durationLabel.text = "Duration: \(duration)m"
			self.titleTextField.text = title
			self.duration = Int16(duration)
			self.rating = rating
			self.poster.image = image
		}
		let noAction = UIAlertAction(title: "No", style: .default) { _ in
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.poster.image = UIImage(named: "movieCamera")
			self.addYourPosterLabel.isHidden = false
			self.toggleLabelAppearance(show: false)
		}
		
		alertController.addAction(yesAction)
		alertController.addAction(noAction)
		
		present(alertController, animated: true)
	}
	
	func presentUnsuccessfulAlert() {
		DispatchQueue.main.sync {
			if keyboardIsActive() {
				moveTextView(opinionTextView, moveDistance: -150, up: false)
				opinionTextView.resignFirstResponder()
			}
			let alertController = UIAlertController(title: "Sorry", message: "Failed loading data from the web :( \nYou can still choose the poster from your image library", preferredStyle: .alert)
			let gotItAction = UIAlertAction(title: "Got it!", style: .default) { _ in
				self.poster.image = UIImage(named: "movieCamera")
				self.addYourPosterLabel.isHidden = false
			}
			let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
				self.guessTheMovie()
			}
			alertController.addAction(gotItAction)
			alertController.addAction(tryAgainAction)
			present(alertController, animated: true)
		}
	}
	
	func toggleLabelAppearance(show: Bool) {
		self.durationLabel.isHidden = !show
		self.yearLabel.isHidden = !show
		self.seeReviews.isHidden = !show
		self.ratingLabel.isHidden = !show
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
		if usersRating != 0 {
			for index in 0..<Int(usersRating) {
				ratingButtons[index].setImage(UIImage(named: "filledStar"), for: .normal)
			}
		}
	}
	
	func keyboardIsActive() -> Bool {
		if opinionTextView.isFirstResponder {
			return true
		}
		return false
	}
	
	func isAlreadyInCollection(title: String) -> Bool {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
		fetchRequest.predicate = NSPredicate(format: "title == %@", title)
		do {
			let count = try context.count(for: fetchRequest)
			if count > 0 {
				print("\(title) already exists")
				return true
			} else {
				return false
			}
		} catch {
			let alertController = UIAlertController(title: "Sorry", message: "Failed to fetch data", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default)
			alertController.addAction(okAction)
			present(alertController, animated: true)
			return false
		}
	}
}

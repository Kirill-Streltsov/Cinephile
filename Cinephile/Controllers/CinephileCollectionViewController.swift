//
//  MyMoviesCollectionViewController.swift
//  MyMovies
//
//  Created by Кирилл on 31.05.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CinephileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	var collectionViewFlowLayout: UICollectionViewFlowLayout!
	var indexOfCell = 0
	private var movies: [Movie] = []

	override func viewWillAppear(_ animated: Bool) {
		collectionView.reloadData()
		getMovies()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return movies.count == 0 ? 1 : movies.count
    }
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
		let index = indexPath.row
		
		if movies.isEmpty {
			cell.titleLabel.isHidden = true
			cell.noMoviesLabel.isHidden = false
			cell.noMoviesLabel.text = "Tap '+' to add your first movie"
		} else {
			cell.titleLabel.isHidden = false
			cell.titleLabel.isHidden = false
			cell.noMoviesLabel.isHidden = true
			if movies[index].poster != nil {
				cell.poster.image = UIImage(data: movies[index].poster!)
				cell.titleLabel.text = ""
			} else {
				cell.poster.image = UIImage(named: "clapperBoard")
				cell.titleLabel.text = movies[index].title
			}
			cell.shadowDecorate()
		}
		return cell
	}
 
	
	// MARK: Cell size (Layout)
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if movies.isEmpty {
			let guide = view.safeAreaLayoutGuide
			return CGSize(width: guide.layoutFrame.size.width, height: guide.layoutFrame.size.height)
		} else {
			let itemsPerRow: CGFloat = 2
			let paddingWidth: CGFloat = 20 * (itemsPerRow + 1)
			let availableWidth = collectionView.frame.width - paddingWidth
			let widthPerItem = availableWidth / 2
			let heightPerItem = widthPerItem * 1.5
			return CGSize(width: widthPerItem, height: heightPerItem)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if movies.isEmpty {
			return additionalSafeAreaInsets
		} else {
			return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		indexOfCell = indexPath.row
		performSegue(withIdentifier: "editMovie", sender: self)
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		if movies.isEmpty {
			return false
		} else {
			return true
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "editMovie":
			let detailVC = segue.destination as! DetailViewController
			detailVC.titleName = movies[indexOfCell].title!
			if let opinion = movies[indexOfCell].opinion {
				detailVC.opinion = opinion
			}
			
			detailVC.rating = movies[indexOfCell].rating
			detailVC.usersRating = movies[indexOfCell].usersRating
			detailVC.year = movies[indexOfCell].year
			detailVC.duration = movies[indexOfCell].runningTimeInMinutes
			detailVC.mode = .edit
			detailVC.wasFoundInTheWeb = movies[indexOfCell].wasFound
			if let image = movies[indexOfCell].poster {
				detailVC.image = UIImage(data: image)
			}
		case "addMovie":
			let detailVC = segue.destination as! DetailViewController
			detailVC.mode = .add
		default:
			print("Error occured during navigation")
		}
	}

	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		switch segue.identifier {
//		case "editMovie":
//			if let indexPath = self.collectionView!.indexPathsForSelectedItems?.first
//			{
//				let index = indexPath.row
//				let movieDetailVC = segue.destination as! DetailViewController
//				movieDetailVC.titleTextField.text = movies[index].title
//				movieDetailVC.yearLabel.text = "\(movies[index].year)"
//				movieDetailVC.durationLabel.text = "\(movies[index].runningTimeInMinutes)"
//				movieDetailVC.ratingLabel.text = "\(movies[index].rating)"
//			}
//		case "addMovie":
//			let movieDetailVC = segue.destination as! DetailViewController
//			movieDetailVC.titleTextField?.becomeFirstResponder()
//		default:
//			print("error occured")
//		}
//	}
	
	
	@IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
		
	}
	
	func getMovies() {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		
		do {
			movies = try context.fetch(fetchRequest)
		} catch {
			print(error)
		}
	}
	
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

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

class MyMoviesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	var collectionViewFlowLayout: UICollectionViewFlowLayout!
	
	override func viewWillAppear(_ animated: Bool) {

//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
//		let context = appDelegate.persistentContainer.viewContext
//		let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
//		let movie = NSManagedObject(entity: entity!, insertInto: context)
//		let image = UIImage(named: "Dißman")
//		let data = image?.pngData()
//		movie.setValue(["Robert", "Joe"], forKey: "actors")
//		movie.setValue(320, forKey: "duration")
//		movie.setValue(data!, forKey: "poster")
//		movie.setValue(9.7, forKey: "rating")
//		movie.setValue("The Irishman", forKey: "title")
//		movie.setValue(8.0, forKey: "usersRating")
//		movie.setValue(2019, forKey: "year")
	
//		do {
//			try context.save()
//		} catch {
//			print("Failed saving")
//		}
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
        return 2
    }
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell

//		var movies: [Movie] = []
//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
//		let context = appDelegate.persistentContainer.viewContext
//
//		let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
//
//		do {
//			movies = try context.fetch(fetchRequest)
//		} catch {
//			print(error)
//		}
//
//		cell.poster.image = UIImage(data: movies[indexPath.row].poster!)
		
		cell.shadowDecorate()
		return cell
	}
 
	
	// MARK: Cell size (Layout)
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow: CGFloat = 2
		let paddingWidth: CGFloat = 20 * (itemsPerRow + 1)
		let availableWidth = collectionView.frame.width - paddingWidth
		let widthPerItem = availableWidth / 2
		let heightPerItem = widthPerItem * 1.5
		return CGSize(width: widthPerItem, height: heightPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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

//
//  MovieCollectionViewCell.swift
//  MyMovies
//
//  Created by Кирилл on 31.05.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var poster: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var noMoviesLabel: UILabel!
	@IBOutlet weak var deleteLabel: UILabel!
	//если постером является дефолтная штука, то написать название фильма, так же поместить звёзды
}

extension UICollectionViewCell {
	func shadowDecorate() {
		let radius: CGFloat = 10
		contentView.layer.cornerRadius = radius
		contentView.layer.borderWidth = 1
		contentView.layer.borderColor = UIColor.clear.cgColor
		contentView.layer.masksToBounds = true

		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 1.0)
		layer.shadowRadius = 2.0
		layer.shadowOpacity = 0.5
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
		layer.cornerRadius = radius
	}
}

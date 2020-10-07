//
//  ReviewsViewController.swift
//  Cinephile
//
//  Created by Кирилл on 20.06.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {

	@IBOutlet weak var defaultAvatar: UIImageView!
	@IBOutlet weak var author: UILabel!
	@IBOutlet weak var reviewTitle: UITextField!
	@IBOutlet weak var reviewText: UITextView!
	@IBOutlet weak var leadingConstraint: NSLayoutConstraint!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		leadingConstraint.constant = view.frame.size.width / 2
		reviewTitle.minimumFontSize = 10
		reviewTitle.adjustsFontSizeToFitWidth = true
	}
	
	override func viewDidLoad() {
		defaultAvatar.layer.cornerRadius = defaultAvatar.frame.width / 2
		defaultAvatar.layer.borderWidth = 1.0
		defaultAvatar.layer.borderColor = UIColor.lightGray.cgColor
		defaultAvatar.clipsToBounds = true
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

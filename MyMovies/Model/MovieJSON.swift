//
//  JSONMovie.swift
//  MyMovies
//
//  Created by Кирилл on 01.06.2020.
//  Copyright © 2020 Kirill Streltsov. All rights reserved.
//

import Foundation

struct MovieJSON: Codable {
	let runningTimeInMinutes: Int?
	let title: String?
	let year: Int?
	let image: Image?
}

struct Image: Codable {
	let url: String?
}

struct FoundInformation: Codable {
	let results: [MovieJSON]?
}

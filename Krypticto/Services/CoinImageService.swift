//
//  CoinImageService.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
	
	@Published var image: UIImage? = nil
	
	private var imageSubscription: AnyCancellable?
	let imageName: String
	let folderName: String = "coin_images"
	let fileManager: LocalFileManager = LocalFileManager.instance
	
	
	init(urlString: String, imageName: String) {
		self.imageName = imageName
		fetchCoinImage(urlString: urlString, imageName: imageName)
	}
	
	private func fetchCoinImage(urlString: String, imageName: String) {
		if let imageFromFile = fileManager.getImage(imageName: imageName, folder: folderName) {
			self.image = imageFromFile
			print("Coin image is picked from file")
		} else {
			downloadCoinImage(urlString: urlString)
			print("Coin image is downloading")
		}
	}
	
	private func downloadCoinImage(urlString: String) {
		guard let imageUrl = URL(string: urlString) else {
			return
		}
		imageSubscription =
		NetworkingManager.download(request: imageUrl)
			.tryMap({ (data)->UIImage? in
				return UIImage(data: data)
			})
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
				guard let strongSelf = self, let downloadImage = image else { return }
				strongSelf.image = downloadImage
				strongSelf.imageSubscription?.cancel()
				strongSelf.fileManager.saveImage(image: downloadImage, imageName: strongSelf.imageName, folder: strongSelf.folderName)
			})
	}
}

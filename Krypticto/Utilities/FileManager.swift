//
//  FileManager.swift
//  Krypticto
//
//  Created by kiranjith on 14/07/2024.
//

import Foundation
import SwiftUI

class LocalFileManager {
	static let instance = LocalFileManager()
	private init() {}
	
	func saveImage(image: UIImage, imageName: String, folder: String) {
		guard let data = image.pngData() else {
			return
		}
		createFolderIfNeeded(folderName: folder)
		guard let saveAtUrl = getUrlForImage(imageName: imageName, folderName: folder) else {
			return
		}
		do {
			try data.write(to: saveAtUrl)
		} catch {
			print("Error while saving image \(error)")
		}
				
	}
	
	func getImage(imageName: String, folder: String) -> UIImage? {
		guard let imageUrl = getUrlForImage(imageName: imageName, folderName: folder),
			FileManager.default.fileExists(atPath: imageUrl.path()) else {
			return nil
		}
		return UIImage(contentsOfFile: imageUrl.path())
		
	}
	
	private func getUrlForFolder(folderName: String) -> URL? {
		guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			return nil
		}
		let folderPath = url.appendingPathExtension(folderName)
		return folderPath
	}
	
	private func createFolderIfNeeded(folderName: String) {
		guard let folderPath = getUrlForFolder(folderName: folderName) else{
			return
		}
		
		if (!FileManager.default.fileExists(atPath: folderPath.path())) {
			do {
				try FileManager.default.createDirectory(atPath: folderPath.path(), withIntermediateDirectories: true)
			} catch let error {
				print("Error creating directory. Folder name \(folderName) with \(error)")
			}
		}
	}
	
	private func getUrlForImage(imageName: String, folderName: String) -> URL? {
		guard let folderUrl = getUrlForFolder(folderName: folderName) else {
			return nil
		}
		return folderUrl.appendingPathComponent(imageName + ".png")
	}
	
}

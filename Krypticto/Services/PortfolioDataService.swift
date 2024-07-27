//
//  PortfolioDataService.swift
//  Krypticto
//
//  Created by kiranjith on 24/07/2024.
//

import Foundation
import CoreData


class PortfolioDataService {
	
	private let container: NSPersistentContainer
	private let containerName: String = "PortfolioContainer"
	private let portfolioEntity: String = "PortfolioEntity"
	
	@Published var savedEntities: [PortfolioEntity] = []
	
	init() {
		self.container = NSPersistentContainer(name: containerName)
		container.loadPersistentStores { (_, error) in
			if let error = error {
				print("Error fetching porfolio entities. \(error)")
			}
		}
		self.getPorfolio()
	}
	
	// MARK: PUBLIC
	
	public func updatePortfolio(entity: CoinModel, amount: Double) {
		if let entity = savedEntities.first(where: {
				$0.coinId == entity.id
		}) {
			if amount > 0 {
				update(entity: entity, amount: amount)
			} else {
				removeCoin(entity: entity)
			}
		} else {
			add(coin: entity, amount: amount)
		}
	}
	
	// MARK: PRIVATE
	
	private func getPorfolio() {
		let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntity)
		do {
			savedEntities = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching portfolio entity.\(error)")
		}
	}
	
	private func add(coin: CoinModel, amount: Double) {
		let entity = PortfolioEntity(context: container.viewContext)
		entity.coinId = coin.id
		entity.amount = amount
		applyChanges()
	}
	
	private func update(entity: PortfolioEntity, amount: Double) {
		entity.amount = amount
		applyChanges()
	}
	
	private func removeCoin(entity: PortfolioEntity) {
		container.viewContext.delete(entity)
		applyChanges()
	}
	
	private func applyChanges() {
		save()
		getPorfolio()
	}
	
	private func save() {
		do {
			try container.viewContext.save()
		} catch let error {
			print("Error saving to core data. \(error)")
		}
	}
}

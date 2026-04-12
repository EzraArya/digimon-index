//
//  AppDIContainer.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 13/04/26.
//

import UIKit

final class AppDIContainer {
    
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkService()
    }()
    
    lazy var digimonRepository: DigimonRepositoryProtocol = {
        return DigimonRepository(networkService: networkService)
    }()
        
    func makeDigimonListViewController() -> UIViewController {
        let useCase = FetchDigimonListUseCase(repository: digimonRepository)
        let viewModel = DigimonListViewModel(fetchDigimonListUseCase: useCase)
        return DigimonListViewController(viewModel: viewModel)
    }
}

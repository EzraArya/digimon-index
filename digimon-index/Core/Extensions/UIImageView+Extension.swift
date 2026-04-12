//
//  UIImageView+Extension.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 13/04/26.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        self.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let loadedImage = UIImage(data: data) else { return }
                
                if !Task.isCancelled {
                    DispatchQueue.main.async {
                        self?.image = loadedImage
                    }
                }
            } catch {
                print("Failed to fetch image: \(error.localizedDescription)")
            }
        }
    }
}

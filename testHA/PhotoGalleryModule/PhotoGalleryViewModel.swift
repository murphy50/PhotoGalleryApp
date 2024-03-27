//
//  PhotoGalleryViewModel.swift
//  testHA
//
//  Created by murphy on 27.03.2024.
//

import Foundation
import UIKit

class PhotoGalleryViewModel {
    
    private var model: PhotoGalleryModel
    
    init(model: PhotoGalleryModel) {
        self.model = model
    }
    
    var image: UIImage? {
        return model.image
    }
    
    func setImage(_ image: UIImage?) {
        model.image = image
    }
}

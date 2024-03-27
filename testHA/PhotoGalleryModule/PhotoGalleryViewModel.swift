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
    var imagePicker: ImagePickerManager!
    
    init(model: PhotoGalleryModel) {
        self.model = model
    }
    
    var image: UIImage? {
        get { return model.image }
        set { model.image = newValue }
    }
    
    func setImage(_ image: UIImage?) {
        model.image = image
    }
    
    func addButtonAction() {
        imagePicker.present()
    }
    
    func saveButtonAction(_ savedImage: UIImage) {
        imagePicker.writeToPhotoAlbum(image: savedImage)
    }
    
}

//
//  PhotoGalleryViewModel.swift
//  testHA
//
//  Created by murphy on 27.03.2024.
//

import UIKit
import Combine

class PhotoGalleryViewModel {
    @Published var image: UIImage?
    
    var imagePicker: ImagePickerManager!
    
    func addButtonAction() {
        imagePicker.present()
    }
    
    func saveButtonAction(_ savedImage: UIImage) {
        imagePicker.writeToPhotoAlbum(image: savedImage)
    }
}

extension PhotoGalleryViewModel: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.image = image
    }
}

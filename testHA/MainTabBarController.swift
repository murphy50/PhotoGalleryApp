//
//  MainTabBarController.swift
//  testHA
//
//  Created by murphy on 26.03.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let photoGalleryVC = PhotoGalleryViewController()
        let imagePicker = ImagePickerManager(presentationController: photoGalleryVC, delegate: photoGalleryVC)
        let photoGalleryViewModel = PhotoGalleryViewModel(model: PhotoGalleryModel(image: nil))
        photoGalleryViewModel.imagePicker = imagePicker
        photoGalleryVC.viewModel = photoGalleryViewModel
        
        let settingsViewModel = SettingsViewModel()
        let settingsVC = SettingsViewController()
        settingsVC.viewModel = settingsViewModel
        
        let nav1 = UINavigationController(rootViewController: photoGalleryVC)
        let nav2 = UINavigationController(rootViewController: settingsVC)
        
        self.viewControllers = [nav1, nav2]

        photoGalleryVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        settingsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
    }
}

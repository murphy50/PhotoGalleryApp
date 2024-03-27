//
//  MainTabBarController.swift
//  testHA
//
//  Created by murphy on 26.03.2024.
//

import UIKit

class AppCoordinator {
    var root: UIViewController!

    init(root: UIViewController) {
        self.root = root
    }

    func start() -> UIViewController {
        let tabBarController = UITabBarController()

        let photoGalleryCoordinator = PhotoGalleryCoordinator()
        let settingsCoordinator = SettingsCoordinator()

        tabBarController.viewControllers = [photoGalleryCoordinator.start(), settingsCoordinator.start()]

        root = tabBarController
        return root
    }
}

class PhotoGalleryCoordinator {
    func start() -> UIViewController {
        let photoGalleryVC = PhotoGalleryViewController()
        let photoGalleryViewModel = PhotoGalleryViewModel()
        let imagePicker = ImagePickerManager(presentationController: photoGalleryVC, delegate: photoGalleryViewModel)

        photoGalleryViewModel.imagePicker = imagePicker
        photoGalleryVC.viewModel = photoGalleryViewModel

        let navController = UINavigationController(rootViewController: photoGalleryVC)
        navController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        return navController
    }
}

class SettingsCoordinator {
    func start() -> UIViewController {
        let settingsViewModel = SettingsViewModel()
        let settingsVC = SettingsViewController()
        settingsVC.viewModel = settingsViewModel

        let navController = UINavigationController(rootViewController: settingsVC)
        navController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        return navController
    }
}

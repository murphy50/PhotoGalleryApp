//
//  SettingsViewModel.swift
//  testHA
//
//  Created by murphy on 26.03.2024.
//

import Foundation

class SettingsViewModel {
    private var developers: [Developer] = [Developer(name: "John"), Developer(name: "Mike")]

    var numberOfDevelopers: Int {
        return developers.count
    }

    func developer(at index: Int) -> Developer {
        return developers[index]
    }

    func addDeveloper(withName name: String) {
        let developer = Developer(name: name)
        developers.append(developer)
    }
}

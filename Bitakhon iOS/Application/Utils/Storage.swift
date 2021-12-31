//
// Created by Mickael Belhassen on 31/12/2021.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let suite: Suite


    init(key: String, defaultValue: T, suite: Suite = .default) {
        self.key = key
        self.defaultValue = defaultValue
        self.suite = suite
    }

    var wrappedValue: T {
        get {
            guard let data = getUserDefault().object(forKey: key) as? Data else { return defaultValue }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            getUserDefault().set(data, forKey: key)
        }
    }

    private func getUserDefault() -> UserDefaults {
        switch suite {
            case .default:
                return UserDefaults.standard
            case .custom(let name):
                return UserDefaults(suiteName: name)!
        }
    }

}


extension Storage {

    enum Suite {
        case `default`
        case custom(name: String)
    }

}

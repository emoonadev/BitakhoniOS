//
// Created by Mickael Belhassen on 31/12/2021.
//

import Foundation

typealias Keychainable = Codable
typealias KeychainDictionary = [String: Any]

@propertyWrapper
class KeychainStorage<Model: Codable> {
    let key: String
    let kClass: KClass
    let logHandler: (String) -> ()

    var projectedValue: KeychainStorage { self }

    private lazy var query: KeychainDictionary = [
        kSecClass as String: kClass.rawValue,
        kSecAttrAccount as String: key as Any
    ]

    init(key: String, kClass: KClass = .generic, logHandler: @escaping (String) -> () = { print($0) }) {
        self.key = key
        self.kClass = kClass
        self.logHandler = logHandler
    }

    var wrappedValue: Model? {
        get {
            query[kSecReturnAttributes as String] = true
            query[kSecReturnData as String] = true

            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)

            guard status == errSecSuccess, let keychainItem = item as? [String: Any], let data = keychainItem[kSecValueData as String] as? Data else { return nil }
            return try? JSONDecoder().decode(Model.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }

            let attributes: KeychainDictionary = [
                kSecValueData as String: data as Any
            ]

            var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

            if status == errSecItemNotFound {
                let addQuery = query.merging(attributes) { _, new in new }
                status = SecItemAdd(addQuery as CFDictionary, nil)
            }

            guard status == errSecSuccess else {
                logHandler(convertError(status).localizedDescription)
                return
            }
        }
    }

    func delete() {
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            logHandler(convertError(status).localizedDescription)
            return
        }
    }

    private func convertError(_ error: OSStatus) -> KeychainError {
        switch error {
            case errSecItemNotFound: return .itemNotFound
            case errSecDataTooLarge: return .invalidData
            case errSecDuplicateItem: return .duplicateItem
            default: return .unexpected(error)
        }
    }
}

extension KeychainStorage {
    enum KClass: RawRepresentable {
        typealias RawValue = CFString

        case generic, password, certificate, cryptography, idendity

        init?(rawValue: CFString) {
            switch rawValue {
                case kSecClassGenericPassword:
                    self = .generic
                case kSecClassInternetPassword:
                    self = .password
                case kSecClassCertificate:
                    self = .certificate
                case kSecClassKey:
                    self = .cryptography
                case kSecClassIdentity:
                    self = .idendity
                default:
                    return nil
            }
        }

        var rawValue: CFString {
            switch self {
                case .generic: return kSecClassGenericPassword
                case .password: return kSecClassInternetPassword
                case .certificate: return kSecClassCertificate
                case .cryptography: return kSecClassKey
                case .idendity: return kSecClassIdentity
            }
        }
    }

    enum KeychainError: Error {
        case invalidData
        case itemNotFound
        case duplicateItem
        case incorrectAttributeForClass
        case unexpected(OSStatus)

        var localizedDescription: String {
            switch self {
                case .invalidData: return "Invalid data"
                case .itemNotFound: return "Item not found"
                case .duplicateItem: return "Duplicate Item"
                case .incorrectAttributeForClass: return "Incorrect Attribute for Class"
                case .unexpected(let oSStatus): return "Unexpected error - \(oSStatus)"
            }
        }
    }
}


//
//  Constants.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct APIConstants {
	typealias Header = [String: String]
	#if LOCAL
		static let baseURL = URL(string: "http://127.0.0.1:8080/api/v1/")!
	#else
		static let baseURL = URL(string: "http://127.0.0.1:8080/api/v1/")!
	#endif

	struct Request {
		var url: URL
		var headers: Header?
		var body: [String: Any]?
		var method: HTTPMethod = .post
	}

	enum Route {
		case createUser(_ req: LoginReq)
		case loginUser(email: String, password: String)
		case getEmergency(id: UUID)

		var request: Request {
			var request = Request(url: baseURL, headers: ["Content-Type": "application/json"], body: nil)
			
			switch self {
				case .createUser(let req): post(.users, body: req)
				case .loginUser(let email, let password): login(.users, .login, email: email, password: password)
				case .getEmergency(let id): get(.users, .parameter(id), .emergencies)
			}

			func get(_ path: BTPath...) {
				buidPath(.get, pahtComponent: path)
			}

			func delete(_ path: BTPath...) {
				buidPath(.delete, pahtComponent: path)
			}

			func put<T: Codable>(_ path: BTPath..., body: T? = nil) {
				buidPath(.put, pahtComponent: path)

				if let body = body {
					request.body = try? DictionaryEncoder.encode(body)
				}
			}

			func post<T: Codable>(_ path: BTPath..., body: T? = nil) {
				buidPath(.post, pahtComponent: path)

				if let body = body {
					request.body = try? DictionaryEncoder.encode(body)
				}
			}

			func login(_ path: BTPath..., email: String, password: String) {
				guard let auth = "\(email):\(password)".data(using: .utf8)?.base64EncodedString() else { return }
				buidPath(.post, pahtComponent: path)
				request.headers?["Content-Type"] = "application/json"
				request.headers?["Authorization"] = "Basic \(auth)"
			}

			func buidPath(_ method: HTTPMethod, pahtComponent: [BTPath]) {
				pahtComponent.forEach { request.url.appendPathComponent($0.path) }
				request.method = method
			}

			return request
		}
	}
}

// MARK: - Paths

extension BTPath {
	static let users: BTPath = "users"
	static let login: BTPath = "login"
	static let emergencies: BTPath = "users"
}

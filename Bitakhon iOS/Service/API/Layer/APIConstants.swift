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
		case getActiveEmergencies
		case createUser(_ req: LoginReq)
		case loginUser(email: String, password: String)
		case getEmergency(id: UUID)
		case createEmergency(_ req: CreateOrUpdateEmergencyReq)

		var request: Request {
			var request = Request(url: baseURL, headers: ["Content-Type": "application/json"], body: nil)
			
			switch self {
				case .createUser(let req): post(.users, auth: .none, body: req)
				case .loginUser(let email, let password): login(.users, .login, email: email, password: password)
				case .getEmergency(let id): get(.users, .parameter(id), .emergencies, auth: .bearer)
				case .getActiveEmergencies: get(.users, .me, .emergencies, .active, auth: .bearer)
				case .createEmergency(let req): post(.emergencies, auth: .basic, body: req)
			}

			func get(_ path: BTPath..., auth: AuthMode) {
				buildPath(.get, pahtComponent: path)
				request.headers = auth.headers
			}

			func delete(_ path: BTPath..., auth: AuthMode) {
				buildPath(.delete, pahtComponent: path)
				request.headers = auth.headers
			}

			func put<T: Codable>(_ path: BTPath..., auth: AuthMode, body: T? = nil) {
				buildPath(.put, pahtComponent: path)

				if let body = body {
					request.body = try? DictionaryEncoder.encode(body)
				}

				request.headers = auth.headers
			}

			func post<T: Codable>(_ path: BTPath..., auth: AuthMode, body: T? = nil) {
				buildPath(.post, pahtComponent: path)

				if let body = body {
					request.body = try? DictionaryEncoder.encode(body)
				}

				request.headers = auth.headers
			}

			func login(_ path: BTPath..., email: String, password: String) {
				guard let auth = "\(email):\(password)".data(using: .utf8)?.base64EncodedString() else { return }
				buildPath(.post, pahtComponent: path)
				request.headers?["Content-Type"] = "application/json"
				request.headers?["Authorization"] = "Basic \(auth)"
			}

			func buildPath(_ method: HTTPMethod, pahtComponent: [BTPath]) {
				pahtComponent.forEach { request.url.appendPathComponent($0.path) }
				request.method = method
			}

			return request
		}

		enum AuthMode {
			case bearer, basic, none

			var headers: Header {
				var headers = Header()
				headers["Content-Type"] = "application/json"

				switch self {
					case .bearer:
						if let accessToken = KeychainManager.userAccessToken {
							headers["Authorization"] = "Bearer \(accessToken)"
						}
					case .basic:
						if let email = UserDefaultsManager.loggedUser?.email, let password = KeychainManager.userPassword, let encodedAuth = "\(email):\(password)".data(using: .utf8)?.base64EncodedString() {
							headers["Content-Type"] = "application/json"
							headers["Authorization"] = "Basic \(encodedAuth)"
						}
					case .none:
						break
				}

				return headers
			}
		}
	}
}

// MARK: - Paths

extension BTPath {
	static let me: BTPath = "me"
	static let users: BTPath = "users"
	static let login: BTPath = "login"
	static let emergencies: BTPath = "emergencies"
	static let active: BTPath = "active"
}

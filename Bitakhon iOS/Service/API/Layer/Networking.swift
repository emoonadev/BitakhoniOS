//
//  Networking.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

protocol ServerResponseModel {
	associatedtype T

	var code: Int { get }
	var message: String { get }
	var data: T? { get }
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
}

protocol NetworkingService {
	func request<T: Decodable & ServerResponseModel>(url: URL, method: HTTPMethod, headers: [String: String]?, queryItems: [URLQueryItem]?, body: [String: Any]?, completion: @escaping (URLResponse?, Result<T, Error>) -> ())

	var handleCustomErrors: ((_ statusCode: Int, _ message: String) -> Error)? { get set }
}

extension NetworkingService {
	func request<T: Decodable & ServerResponseModel>(url: URL, method: HTTPMethod, headers: [String: String]? = nil, queryItems: [URLQueryItem]? = nil, body: [String: Any]? = nil, completion: @escaping (URLResponse?, Result<T, Error>) -> ()) {
		request(url: url, method: method, headers: headers, queryItems: queryItems, body: body, completion: completion)
	}
}

class Networking: NetworkingService {
	private let urlSession = URLSession.shared
	var handleCustomErrors: ((_ statusCode: Int, _ message: String) -> Error)?

	func request<T: Decodable & ServerResponseModel>(url: URL, method: HTTPMethod, headers: [String: String]? = nil, queryItems: [URLQueryItem]? = nil, body: [String: Any]? = nil, completion: @escaping (URLResponse?, Result<T, Error>) -> ()) {
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			completion(nil, .failure(BTError.invalidEndpoint))
			return
		}

		urlComponents.queryItems = queryItems

		guard let url = urlComponents.url else {
			completion(nil, .failure(BTError.invalidEndpoint))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		var requestStr = "--> \(method) \(request.url?.absoluteString ?? ""): "

		if let headers = headers {
			request.allHTTPHeaderFields = headers
			requestStr += String(describing: headers) + " - "
		}

		if let body = body {
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: body)
				if let data = request.httpBody {
					requestStr += String(data: data, encoding: .utf8) ?? ""
				}
			} catch {
				print(error.localizedDescription)
			}
		}

		print(requestStr)

		urlSession.dataTask(with: request) { result in
			switch result {
				case .success(let (response, data)):
					print("<-- \((response as? HTTPURLResponse)?.statusCode ?? -1) \(response.url?.absoluteString ?? ""): \(String(data: data, encoding: .utf8))")
					do {
						let values = try JSONDecoder().decode(T.self, from: data)
						guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200 ..< 299 ~= statusCode else {
							if let customError = self.handleCustomErrors {
								completion(response, .failure(customError((response as? HTTPURLResponse)?.statusCode ?? values.code, values.message)))
							} else {
								completion(response, .failure(BTDynamicError(title: values.message, description: values.message, code: values.code)))
							}
							return
						}

						completion(response, .success(values))
					} catch {
						completion(response, .failure(BTDynamicError(title: "Json parse error", description: error.localizedDescription, code: -1)))
					}

				case .failure(let error):
					completion(nil, .failure(BTDynamicError(title: error.localizedDescription, description: error.localizedDescription, code: -4)))
			}
		}.resume()
	}
}

// MARK: - Extension

extension URLSession {
	func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> ()) -> URLSessionDataTask {
		return dataTask(with: urlRequest) { data, response, error in
			if let error = error {
				result(.failure(error))
				return
			}

			guard let response = response, let data = data else {
				let error = NSError(domain: "error", code: 0, userInfo: nil)
				result(.failure(error))
				return
			}

			result(.success((response, data)))
		}
	}
}

extension Data {
	var jsonPretty: NSString? {
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
		      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
		      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

		return prettyPrintedString
	}
}

protocol BTPathParameter {
	var emValue: String { get }
}

enum BTPath: ExpressibleByStringInterpolation {
	case constant(String), parameter(BTPathParameter)

	var path: String {
		switch self {
			case .constant(let value): return value
			case .parameter(let value): return value.emValue
		}
	}

	public init(stringLiteral value: String) {
		self = .constant(value)
	}
}

extension String: BTPathParameter {
	var emValue: String { self }
}

extension UUID: BTPathParameter {
	var emValue: String { uuidString }
}

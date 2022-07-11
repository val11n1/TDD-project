//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 10.05.2022.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {

    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp()  {
        
        super.setUp()
        
        mockURLSession = MockURLSession(data: nil, urlResponce: nil, responceError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
        
        
    }

    override func tearDown()  {
        super.tearDown()
    }

    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in}
        sut.login(withName: "name", password: "%qwerty", completionHandler:completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectPath() {
        
        userLogin()
        
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExpectedQueryParameters() {
        
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    // token -> Data -> completionHandler -> DataTask -> urlSession
    func testSuccessfulLoginCreatesToken() {
        
        let JSONDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: JSONDataStub, urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token expectation")
        
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            
            caughtToken = token
            tokenExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        
        mockURLSession = MockURLSession(data: Data(), urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenDataIsNilReturnsError() {
        
        mockURLSession = MockURLSession(data: nil, urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenResponceReturnsError() {
        
        let JSONDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let responceError = MockError()
        mockURLSession = MockURLSession(data: JSONDataStub, urlResponce: nil, responceError: responceError)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            
            XCTAssertNotNil(caughtError)
        }
    }
}


extension APIClientTests {
    
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            
            guard let url = url else { return nil }
            
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponce: URLResponse?, responceError: Error?) {
            
            mockDataTask = MockURLSessionDataTask(data: data, urlResponce: urlResponce, responceError: responceError)
        }
        
         func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
             self.url = url
             //return URLSession.shared.dataTask(with: url)
             mockDataTask.completionHandler = completionHandler
             return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponce: URLResponse?
        private let responceError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponce: URLResponse?, responceError: Error?) {
            
            self.data = data
            self.urlResponce = urlResponce
            self.responceError = responceError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponce,
                    self.responceError
                )
            }
        }
    }
    
    class MockError: Error {
        
        
    }
}

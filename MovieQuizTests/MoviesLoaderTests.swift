//
//  MoviesLoaderTests.swift
//  MoviesLoaderTests
//
//  Created by Максим Казанцев on 18.06.2023.
//

import XCTest

@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {

    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loader expectation")
        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                // сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_): // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        
        waitForExpectations(timeout: 1)
        
        
        // Then
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что  хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // When
        let expectation = expectation(description: "Loader expectation")
        loader.loadMovies { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
        // Then
    }
}

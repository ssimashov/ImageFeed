//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Sergey Simashov on 18.11.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 20))
        
        loginTextField.tap()
        loginTextField.typeText("")// fake data from network
        app.buttons["Done"].tap()
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("") // fake data from network
        sleep(1)
        app.buttons["Done"].tap()
        
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        loginButton.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS 'Continue as'")
        let createAccountText = app.webViews.buttons.containing(predicate)
        let continueButton = createAccountText.element(boundBy: 0)
        
        if continueButton.waitForExistence(timeout: 5) {
            continueButton.tap()
        }
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp(velocity: .slow)
        
        sleep(2)
        
        app.swipeDown()
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        sleep(5)
        cellToLike.buttons["LikeButton"].tap()
        sleep(5)
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(10)
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(20)
        
        let navBackButtonWhiteButton = app.buttons["NavBackButton"]
        navBackButtonWhiteButton.tap()
        
        let feed = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(feed.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(5)
        XCTAssertTrue(app.staticTexts[""].exists)
        
        XCTAssertTrue(app.staticTexts["@"].exists)
        
        app.buttons["ExitButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

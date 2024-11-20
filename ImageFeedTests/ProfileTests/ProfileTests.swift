//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Sergey Simashov on 17.11.2024.
//

import XCTest
@testable import  ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.viewDidLoad()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.updateAvatar()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        let profile: Profile = Profile(
            username: "ekaterina_nov",
            name: "Екатерина Новикова",
            loginName: "@ekaterina_nov",
            bio: "Hello, world!"
        )
        viewController.updateProfileDetails(profile: profile)
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}

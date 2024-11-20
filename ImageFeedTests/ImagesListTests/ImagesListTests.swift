//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Sergey Simashov on 18.11.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterFetchPhotosNextPage() {
        // given
        let presenter = ImagesListViewPresenterSpy()
        
        // when
        presenter.fetchPhotosNextPage()
        
        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled, "Presenter should call fetchPhotosNextPage")
    }
    
    func testPresenterChangeLike() {
        // given
        let presenter = ImagesListViewPresenterSpy()
        let photoId = "123"
        let isLike = true
        
        // when
        presenter.changeLike(photoId: photoId, isLike: isLike) { _ in }
        
        // then
        XCTAssertTrue(presenter.changeLikeCalled, "Presenter should call changeLike")
        XCTAssertEqual(presenter.changeLikePhotoId, photoId, "Photo ID should be passed correctly")
        XCTAssertEqual(presenter.changeLikeIsLike, isLike, "Like status should be passed correctly")
    }
    
    func testViewControllerCallsUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController)
        viewController.presenter = presenter
        
        // when
        viewController.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled, "View should call updateTableViewAnimated")
    }
}

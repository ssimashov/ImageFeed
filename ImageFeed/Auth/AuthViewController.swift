//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 13.08.2024.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2Storage = OAuth2TokenStorage.shared
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                oauth2Storage.token = token
                delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure(let error):
                self.showAlert()
                print("Failed to fetch token: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SignInViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appleButtonView: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Allow pop up to be presented
        GIDSignIn.sharedInstance()?.hostedDomain = nil
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Sets up the apple sign in button.
        setupSignInButton()
    }
    
    func setupSignInButton() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
        //Constrain to position
        button.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            button.centerXAnchor.constraint(equalTo: appleButtonView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: appleButtonView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: appleButtonView.widthAnchor),
            button.heightAnchor.constraint(equalTo: appleButtonView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func handleSignInWithAppleTapped() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }

}




//Sign in with Apple

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid State: A login callback was received, but no login request was sent")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("You are now signed in as \(user.uid)")
                    
                    //redirect once signed in
                    if let error = error {
                        print("Error logging into Firebase from Apple:", error)
                    }
                    
                    //Change the root ViewController
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    if (authDataResult?.additionalUserInfo!.isNewUser)! {
                        
                        //This is a new user - Go to SignInViewController
                        let SignInNVC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(SignInNVC)
                        
                    } else {
                        
                        //Get the user data
                        currentUser.populateAsCurrentUser() {
                            
                            //Check for filled in info
                            if currentUser.uid == nil {
                                
                                //This is a new user - Go to SignInViewController
                                let SignInNVC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                                
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(SignInNVC)
                            } else {
                                
                                //Sign in to subscribe to topics
                                currentUser.signIn()
                                
                                //This is an existing user - Go to MainTabBarController
                                let HomeVC = storyBoard.instantiateViewController(withIdentifier: "MainTBC") as! MainTabBarViewController
                                
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(HomeVC)
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}




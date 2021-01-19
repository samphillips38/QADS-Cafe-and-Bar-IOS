//
//  AppDelegate.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Set Up window
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        window.rootViewController = MainNavigationViewController()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: GIDSignInDelegate Protocol
    
    //Handle Google SignIn URL
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        GIDSignIn.sharedInstance()?.hostedDomain = nil
      // ...
      if let error = error {
        print(error)
        //Handle the error
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
      // ..
        // Login/Sign up to Firebase
        FirebaseAuth.Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error logging into Firebase from Google:", error)
            }
            
            print("Successfully logged into Firebase with Google")
            
            //Change the root ViewController
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            if (authResult?.additionalUserInfo!.isNewUser)! {
                
                //This is a new user
                
                //Create Document
            
                //Upload information to Firebase
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser?.uid
                let crsid = (Auth.auth().currentUser!.email)?.components(separatedBy: "@")[0]
                
                db.collection("users").document(uid!).setData([
                    "uid": uid!,
                    "crsid": crsid ?? "UNKNOWN"
                ]) { (error) in
                    if error != nil {
                        //show error message
                        print("There was an error: ", error ?? "UNKNOWN")
                    }
                }
                
                //Change Navigation View controller
                let MainTabBarVC = storyBoard.instantiateViewController(withIdentifier: "MainTBC") as! UITabBarController
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarVC)
                
            } else {
                
                //Get the user data
                currentUser.populateAsCurrentUser() {
                    
                    //Check for filled in info
                    if currentUser.uid == nil {
                        
                        //Upload information to Firebase
                        let db = Firestore.firestore()
                        let uid = Auth.auth().currentUser?.uid
                        let crsid = (Auth.auth().currentUser!.email)?.components(separatedBy: "@")[0]
                        
                        db.collection("users").document(uid!).setData([
                            "uid": uid!,
                            "crsid": crsid ?? "UNKNOWN"
                        ]) { (error) in
                            if error != nil {
                                //show error message
                                print("There was an error: ", error ?? "UNKNOWN")
                            }
                        }

                        //This is a new user - Go to SignInViewController
                        let MainTabBarVC = storyBoard.instantiateViewController(withIdentifier: "MainTBC") as! UITabBarController
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarVC)
                        
                    } else {

                        //Sign in to subscribe to topics (currently does nothing)
                        currentUser.signIn()

                        //This is an existing user - Go to MainTabBarController
                        let MainTabBarVC = storyBoard.instantiateViewController(withIdentifier: "MainTBC") as! UITabBarController
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarVC)
                    }
                }
            }
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("User Disconnected")
        
    }


}


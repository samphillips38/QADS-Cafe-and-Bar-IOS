//
//  SignUpViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 01/02/2021.
//

import UIKit
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButtion: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var TandCSwitch: UISwitch!
    @IBOutlet weak var TandCTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Text field delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        currentUser.getTandCLink { linkString in
            
            let attributedString = NSMutableAttributedString(string: "I have read and agree to the Terms and Conditions.")
            attributedString.addAttribute(.link, value: linkString, range: NSRange(location: 29, length: 21))
            
            self.TandCTextView.attributedText = attributedString
            self.TandCTextView.textColor = .white
        }
        
        
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
        }
    

    func validateFields() -> String? {
        let check1 = firstNameTextField.text?.filter { !$0.isWhitespace }
        let check2 = lastNameTextField.text?.filter { !$0.isWhitespace }
        
        if check1 == "" || check2 == "" {
            return "Please fill in all details"
        } else if !TandCSwitch.isOn {
            return "Please Agree to Terms and Conditions"
        } else {
            return nil
        }
        
    }
    
    
    //MARK:- Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        //Move to the next text field. YearTextField removes keyboard
        switch textField {
        case self.firstNameTextField:
            self.lastNameTextField.becomeFirstResponder()
        default:
            self.lastNameTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: textField.frame.origin.y/2), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
    }
    
    //MARK:- Button Actions
    
    @IBAction func signUpButton(_ sender: Any) {
        let error = validateFields()
        
        if error == nil {
            currentUser.firstName = firstNameTextField.text
            currentUser.lastName = lastNameTextField.text
            
            // Make document in firebase
            currentUser.make {
                
                //Sign in to subscribe to topics
                currentUser.signIn()

                //Go to MainTabBarController
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let MainTabBarVC = storyBoard.instantiateViewController(withIdentifier: "MainTBC") as! UITabBarController
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarVC)
            }
            
        } else {
            errorLabel.isHidden = false
            errorLabel.text = error
        }
    }
    
    @IBAction func TandCButton(_ sender: Any) {
    }
    
}

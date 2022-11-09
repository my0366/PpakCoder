//
//  LoginView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/04.
//

import Foundation
import UIKit

class LoginView : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailPickerTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: RoundedButton!
    
    let emails = ["naver.com", "gmail.com", "직접입력"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        emailPickerTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        emailPickerTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = "\(emailTextField.text ?? "")@\(emailPickerTextField.text ?? "")"
        
        if let password = passwordTextField.text {
            UserViewModel.shared.login(email: email, password: password) { res in
                let alert = UIAlertController(title: "", message: res, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                if res == "로그인에 성공하였습니다" {
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarStoryBoard") else {
                        return
                    }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                } else {
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension LoginView : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emails.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return emails[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        emailPickerTextField.text = emails[row]
    }
    
}

//
//  LoginViewController.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 28.05.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    let store: Store
    
    let step: Step
    
    var password = ""
    
    let routeToMaint: (()-> Void)
    
    
    init(store: Store, step: Step, routeToMaint:@escaping ()-> Void) {
        self.store = store
        self.step = step
        self.routeToMaint = routeToMaint
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    
    lazy var sendPasswordButtonView: CustomButton = {
        let button = CustomButton(){
            self.clickButton()
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneView()
        addSubviews()
        setupConstraints()
        
    }
    
    private func tuneView() {
        view.backgroundColor = .white
        
        switch step{
        case .login:
            title = "Введите пароль"
            passwordLabel.text = "Введите пароль"
            sendPasswordButtonView.setTitle("Войти", for: .normal)
        case .password:
            title = "Создать пароль"
            passwordLabel.text = "Создать пароль"
            sendPasswordButtonView.setTitle("Создать пароль", for: .normal)
        case .repeatPassword:
            passwordLabel.text = "Повторите пароль"
            title = "Повторите пароль"
            sendPasswordButtonView.setTitle("Повторите пароль", for: .normal)
        }
        
        
    }
    
    private func addSubviews() {
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(sendPasswordButtonView)
        
        
        
    }
    
    private func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            sendPasswordButtonView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            sendPasswordButtonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            sendPasswordButtonView.heightAnchor.constraint(equalToConstant: 50),
            sendPasswordButtonView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            
        ])
        
    }
    
    
    func clickButton(){
        if(passwordTextField.text?.count ?? 0 < 4){
            TextPicker.showMessage(in: self, title: "Ошика", message: "Слишком короткий пароль"){[weak self] in
                guard let self else {return}
                self.clear(self.step)
            }
            return
        }
        switch step {
        case .login:
            if store.load() != passwordTextField.text {
                TextPicker.showMessage(in: self, title: "Ошика", message: "Неверный пароль") {[weak self] in
                    self?.clear(.login)
                }
                return
            }
            routeToMaint()
        case .password:
            let loginViewController = LoginViewController(store: store, step: .repeatPassword, routeToMaint: routeToMaint)
            loginViewController.password = passwordTextField.text ?? ""
            navigationController?.pushViewController(loginViewController, animated: true)
        case .repeatPassword:
            if(password != passwordTextField.text){
                TextPicker.showMessage(in: self, title: "Ошика", message: "Пароли не совпадат"){ [weak self] in
                    self?.clear(.password)
                }
                return
            }
            store.save(item: passwordTextField.text!)
            routeToMaint()
            // переход
        }
        
        
    }
    func clear(_ step: Step){
        let vc = LoginViewController(store: store, step: step, routeToMaint: routeToMaint)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

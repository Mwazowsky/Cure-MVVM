//
//  LoginFormCUREUIKit.swift
//  Cure
//
//  Created by MacBook Air MII  on 13/5/25.
//

import UIKit

class LoginFormCUREUIKit: UIView {
    private let viewModel: LoginViewModel
    
    // UI Components
    /// UILabels
    private lazy var titleLbl: TitleTxtCUREUIKit = TitleTxtCUREUIKit(textStyle: .title1, title: "Welcome to Cure")
    
    /// UITextFields
    private lazy var emailTF: DefaultTFCUREUIKit = DefaultTFCUREUIKit(title: "Email", isSecure: false)
    
    private lazy var passwordTF: DefaultTFCUREUIKit = DefaultTFCUREUIKit(title: "Password", isSecure: true)
    
    /// UIButton
    private lazy var loginBtn: PrimaryBtnCUREUIKit = PrimaryBtnCUREUIKit(
        backgroundColor: DesignTokens.LegacyColors.primary,
        title: "Login"
    )
    
    private lazy var registerBtn: TextBtnCUREUIKit = TextBtnCUREUIKit(title: "Don't have an account? Register")
    
    private lazy var forgotPasswordBtn: TextBtnCUREUIKit = TextBtnCUREUIKit(title: "Forgot Password?")
    
    /// Spinner/Loader
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
        
        viewModel.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        
        addSubview(titleLbl)
        
        // Setup TextFields
        addSubview(emailTF)
        addSubview(passwordTF)
        
        // Setup Buttons
        addSubview(loginBtn)
        addSubview(registerBtn)
        addSubview(forgotPasswordBtn)
        
        addSubview(errorLabel)
        addSubview(activityIndicator)
        
        // Configure View Components
        emailTF.delegate = self
        passwordTF.delegate = self
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailTF.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 40),
            emailTF.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTF.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 20),
            passwordTF.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordTF.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            loginBtn.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            loginBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 10),
            forgotPasswordBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registerBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 20),
            registerBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        emailTF.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        loginBtn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
                self?.loginBtn.isEnabled = false
            } else {
                self?.activityIndicator.stopAnimating()
                self?.updateLoginButtonState()
            }
        }
        
        viewModel.error.observe(on: self) { [weak self] errorMessage in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                self?.errorLabel.text = errorMessage
                self?.errorLabel.isHidden = false
            } else {
                self?.errorLabel.isHidden = true
            }
        }
        
        viewModel.isLoginButtonEnabled.observe(on: self) { [weak self] isEnabled in
            self?.updateLoginButtonState()
        }
    }
    
    private func updateLoginButtonState() {
        let isEnabled = viewModel.isLoginButtonEnabled.value && !viewModel.isLoading.value
        loginBtn.isEnabled = isEnabled
        loginBtn.alpha = isEnabled ? 1.0 : 0.7
    }
    
    // MARK: - Actions
    @objc private func emailTextChanged() {
        viewModel.updateEmail(emailTF.text ?? "")
    }
    
    @objc private func passwordTextChanged() {
        viewModel.updatePassword(passwordTF.text ?? "")
    }
    
    @objc private func loginButtonTapped() {
        viewModel.didTapLoginButton()
    }
    
    @objc private func registerButtonTapped() {
        viewModel.didTapRegisterButton()
    }
    
    @objc private func forgotPasswordButtonTapped() {
        viewModel.didTapForgotPasswordButton()
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        //        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        //        scrollView.contentInset = contentInsets
        //        scrollView.scrollIndicatorInsets = contentInsets
        
        // Scroll to active text field
        var rect = self.frame
        rect.size.height -= keyboardSize.height
        
        //        if let activeField = [emailTF, passwordTF].first(where: { $0.isFirstResponder }) {
        //            let activeRect = activeField.convert(activeField.bounds, to: scrollView)
        //            if !rect.contains(activeRect.origin) {
        //                scrollView.scrollRectToVisible(activeRect, animated: true)
        //            }
        //        }
    }
    
    //    @objc private func keyboardWillHide(notification: NSNotification) {
    //        scrollView.contentInset = .zero
    //        scrollView.scrollIndicatorInsets = .zero
    //    }
    
    @objc private func pushChatContactListVC() {
        guard let userEmail = emailTF.text, !userEmail.isEmpty else {
            return
        }
        
        guard let userPassword = passwordTF.text, !userPassword.isEmpty else {
            return
        }
        
        if userEmail.isValidEmail {
        } else if userPassword.isValidPassword {
        } else {
            print("Invalid email/password format")
        }
    }
}

extension LoginFormCUREUIKit: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushChatContactListVC()
        return true
    }
}

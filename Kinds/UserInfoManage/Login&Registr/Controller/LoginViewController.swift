//
//  LoginViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/25.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {

    var loginButton: UIButton!
    var name: UITextField!
    var pass: UITextField!
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel()
        createUIView()
        setupRx()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func createUIView() {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "login_background")
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view).offset(90)
            make.bottom.equalTo(self.view).offset(-90)
        }
        
        let loginImageView = UIImageView()
        loginImageView.image = UIImage.init(named: "login_logo")
        loginImageView.contentMode = .scaleAspectFit
        bgView.addSubview(loginImageView)
        loginImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(25)
            make.width.height.equalTo(120)
            make.centerX.equalTo(bgView.snp.centerX)
        }
        
        name = UITextField()
        name.layer.masksToBounds = true
        name.layer.cornerRadius = 22
        name.layer.borderWidth = 1
        name.delegate = self
        name.layer.borderColor = PlaceholderTextColor.cgColor
        name.placeholder = "请输入手机号"
        name.clearButtonMode = .whileEditing
        name.textAlignment = .center
        name.keyboardType = .numberPad
        name.font = UIFont.systemFont(ofSize: 16)
        bgView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(loginImageView.snp.bottom).offset(40)
            make.left.equalTo(bgView).offset(15)
            make.trailing.equalTo(bgView).offset(-15)
            make.height.equalTo(44)
        }
        
        pass = UITextField()
        pass.layer.masksToBounds = true
        pass.layer.cornerRadius = 22
        pass.layer.borderWidth = 1
        pass.delegate = self
        pass.layer.borderColor = PlaceholderTextColor.cgColor
        pass.placeholder = "请输入密码"
        pass.clearButtonMode = .whileEditing
        pass.textAlignment = .center
        pass.keyboardType = .default
        pass.font = UIFont.systemFont(ofSize: 16)
        bgView.addSubview(pass)
        pass.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(20)
            make.left.equalTo(bgView).offset(15)
            make.trailing.equalTo(bgView).offset(-15)
            make.height.equalTo(44)
        }
        
        let forgetButton = UIButton()
        forgetButton.setTitle("忘记密码?", for: .normal)
        forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        forgetButton.setTitleColor(NavigationTextColor, for: .normal)
//        forgetButton.addTarget(self, action: #selector(forgetTapped), for: .touchUpInside)
        bgView.addSubview(forgetButton)
        forgetButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(-20)
            make.left.equalTo(bgView).offset(15)
            make.height.equalTo(30)
        }
        
        let rergisterButton = UIButton()
        rergisterButton.setTitle("注册新用户", for: .normal)
        rergisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rergisterButton.setTitleColor(AppMainColor, for: .normal)
        bgView.addSubview(rergisterButton)
        rergisterButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(-20)
            make.trailing.equalTo(bgView).offset(-15)
            make.height.equalTo(30)
        }
        
        loginButton = UIButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.setNormalBackground(normalColor: App_NormalButton_Color, hightedColor: App_HighlightedButton_Color, disableColor: App_DisableButton_Color)
        bgView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(forgetButton.snp.top).offset(-20)
            make.left.equalTo(bgView).offset(15)
            make.trailing.equalTo(bgView).offset(-15)
            make.height.equalTo(44)
        }
        loginButton.isEnabled = false
        
    }
    
    private func setupRx() {
//        let loginValid = loginButton.rx.tap.share(replay: 1)
//
//        loginValid.subscribe(onNext: {
//            print("1234567")
//        }).disposed(by: disposeBag)
        
        loginButton.rx
            .tap
            .throttle(1, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
        
                self.showAlter(title: "提示", message: "111111", cancle: "00000", sure: "1111", sureHandle: { [weak self] in
                    print("1234567")
                    self?.viewModel.POST_Request(finishedCallback: { (Any) in
                        
                    })
                }, cancelHandle: {

                })
                
            })
            .disposed(by: disposeBag)

        name.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
                print("您输入的是：\($0)")
            })
            .disposed(by: disposeBag)
        
        name.rx.text.orEmpty.changed
            .subscribe(onNext: {
                print("您输入的是：\($0)")
            })
            .disposed(by: disposeBag)
        
//        loginButton.rx.tap
//            .subscribe(onNext: {
//                print("1234567")
//            })
//            .disposed(by: disposeBag)
//
//        loginButton.rx.tap.asDriver()
//            .drive(onNext: { [weak self] in
//                print(self!)
//            }).disposed(by: disposeBag)
        
        let nameValid = name.rx.text.orEmpty
            .map{$0.count >= 11 && (self.pass.text!.count >= 6)}
            .share(replay: 1)
        let passValid = pass.rx.text.orEmpty
            .map{$0.count >= 6 && (self.name.text!.count >= 11)}
            .share(replay: 1)
        
        nameValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        passValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        model.loginName.asObservable().bind(to: name.rx.text).disposed(by: disposeBag)
//        model.loginPwd.asObservable().bind(to: pass.rx.text).disposed(by: disposeBag)
        name.rx.text.orEmpty.bind(to: viewModel.loginName).disposed(by: disposeBag)
        pass.rx.text.orEmpty.bind(to: viewModel.loginPwd).disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        loginButton.isEnabled = true
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activateTextFieldLayerColor(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var toBeStr: String = textField.text!
        let rag = toBeStr.toRange(range)
        toBeStr = toBeStr.replacingCharacters(in: rag!, with: string)
        
        if (textField == name) {
            return toBeStr.count <= 11
        } else if (textField == pass) {
            return toBeStr.count <= 16
        } else {
            return true
        }
    }
    
    func activateTextFieldLayerColor(textField: UITextField) {
        if textField == name {
            name.layer.borderColor = AppMainColor.cgColor
            pass.layer.borderColor = PlaceholderTextColor.cgColor
        } else {
            name.layer.borderColor = PlaceholderTextColor.cgColor;
            pass.layer.borderColor = AppMainColor.cgColor;
        }
    }
}

extension LoginViewController {
    func viewCreateLoad() {
        
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        //创建文本输出框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        //创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:300, height:30))
        self.view.addSubview(label)
        
        //创建按钮
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        
        
        //当文本框内容改变
        let input = inputField.rx.text.orEmpty.asDriver() // 将普通序列转换为 Driver
            .throttle(0.3) //在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        //内容绑定到另一个输入框中
        input.drive(outputField.rx.text)
            .disposed(by: disposeBag)
        
        //内容绑定到文本标签中
        input.map{ "当前字数：\($0.count)" }
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        //根据内容字数决定按钮是否可用
        input.map{ $0.count > 5 }
            .drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func monitorMultiple() {
        Observable.combineLatest(name.rx.text.orEmpty, pass.rx.text.orEmpty) {
            textValue1, textValue2 -> String in
            return "你输入的号码是：\(textValue1)-\(textValue2)"
            }
            .map { $0 }
            .bind(to: loginButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    func seturnKB() {
        //在用户名输入框中按下 return 键
        name.rx.controlEvent(.editingDidEndOnExit).subscribe({_ in
//            [weak self] (_) in
            self.pass.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        //在密码输入框中按下 return 键
        pass.rx.controlEvent(.editingDidEndOnExit).subscribe({
            [weak self] (_) in
            self?.pass.resignFirstResponder()
        }).disposed(by: disposeBag)
        
    }
    
    func textViewUI() {
        var textView: UITextView = UITextView()
        //开始编辑响应
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        //结束编辑响应
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
            .disposed(by: disposeBag)
        
        //内容发生变化响应
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            })
            .disposed(by: disposeBag)
        
        //选中部分变化响应
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            })
            .disposed(by: disposeBag)
    }
    
    func timerChange() {
        let button = UIButton()
        
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        //根据索引数拼接最新的标题，并绑定到button上
        timer.map{"计数\($0)"}
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        timer.map(formatTimeInterval)
            .bind(to: button.rx.attributedTitle())
            .disposed(by: disposeBag)
    }
    
    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedStringKey.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    
}

//
//  ViewController.swift
//  blindOsu
//
//  Created by Vidur Modgil on 6/28/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var textField: UITextField!;
    var submitButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField = UITextField();
        submitButton = UIButton();
        submitButton.setTitle("Play", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitleColor(.systemBlue, for: .normal)
        submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        
        textField.isHidden = false;
        textField.isHidden = false;
        
        textField.placeholder = "Enter Song URL/video title here"
        textField.sizeToFit()
        
        view.addSubview(textField)
        view.addSubview(submitButton)
        
        textField.center = self.view.center;
        
        submitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
        view.setNeedsLayout()
        
    }
    
    @IBAction func submitForm() {
        if let url = textField.text {
            textField.isHidden = true;
            submitButton.isHidden = true;
            print("Shit")
            ConfigState.shared.setSong(song: url)
            let controller = StateManager(viewController: self, initState: .initView)
            controller.transition(to: .gameView)
        }
    }

}

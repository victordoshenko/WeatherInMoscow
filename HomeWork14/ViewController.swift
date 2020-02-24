//
//  ViewController.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 21.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firstNameTextField.text = Persistance.shared.userFirstName
        lastNameTextField.text = Persistance.shared.userLastName
    }

    @IBAction func firstNameChanged(_ sender: UITextField) {
        Persistance.shared.userFirstName = sender.text
    }
    @IBAction func lastNameChanged(_ sender: UITextField) {
        Persistance.shared.userLastName = sender.text
    }
    
}


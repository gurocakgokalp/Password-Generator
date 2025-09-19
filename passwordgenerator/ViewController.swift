//
//  ViewController.swift
//  passwordgenerator
//
//  Created by Gökalp Gürocak on 19.09.2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var historyTblVie: UITableView!
    @IBOutlet weak var lenghtLabel: UILabel!
    var passwordLenght: Int = 13
    @IBAction func sliderInt(_ sender: UISlider) {
        passwordLenght = Int(sender.value)
        lenghtLabel.text = String(passwordLenght)
        
    }
    @IBOutlet weak var btnPassword: UIButton!
    let mixedPassword = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:',.<>/?"
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let numbersAndLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var createdPassword = ""
    var selectedIndex: Int? = 0

    @IBOutlet weak var passwordType: UIButton!
    
    func saveHistory() {
        UserDefaults.standard.set(passwordHistory, forKey: "passwordHistory")
    }

    func loadHistory() {
        if let saved = UserDefaults.standard.stringArray(forKey: "passwordHistory") {
            passwordHistory = saved
        }
    }
    
    func setupPopUpButton() {
            let options = ["Only Letters", "Only Numbers", "Letters + Numbers", "Mixed include Special Characters"]

            let popUpButtonClosure = { (action: UIAction) in
                if let index = options.firstIndex(of: action.title) {
                    self.selectedIndex = index
                }
            }

            passwordType.menu = UIMenu(children: options.map { UIAction(title: $0, handler: popUpButtonClosure) })
            passwordType.showsMenuAsPrimaryAction = true
        }

    //nil = boş

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return passwordHistory.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = passwordHistory[indexPath.row]
            return cell
        }
    
    @IBAction func copyClipboardBTN(_ sender: Any) {
        if createdPassword != "" {
            UIPasteboard.general.string = createdPassword
            let alert = UIAlertController(title: createdPassword, message: "Copied to Clipboard", preferredStyle: .alert)
            self.present(alert, animated: true)

            // 1 sn delay sonra close
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true)
            }
        }
        

    }
    
    var passwordHistory: [String] = []

    //
    @IBAction func btnCreate(_ sender: Any) {
        createdPassword = ""
        let index = selectedIndex
        for _ in 1...passwordLenght {
            switch index {
                    case 0:
                let randomString = letters.randomElement()!
                createdPassword.append(randomString)
                vibrate()
                    case 1:
                let randomString1 = numbers.randomElement()!
                createdPassword.append(randomString1)
                vibrate()
                    case 2:
                let randomString2 = numbersAndLetters.randomElement()!
                createdPassword.append(randomString2)
                vibrate()
                    case 3:
                let randomString3 = mixedPassword.randomElement()!
                createdPassword.append(randomString3)
                vibrate()
                    default:
                        break
                    }
        }
        passwordHistory.insert(createdPassword, at: 0)
            if passwordHistory.count > 5 {
                passwordHistory.removeLast()
            }
        btnPassword.setTitle(createdPassword, for: .normal)
        saveHistory()
        historyTblVie.reloadData()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpButton()
        historyTblVie.delegate = self
        historyTblVie.dataSource = self
        loadHistory()
        historyTblVie.reloadData()
        historyTblVie.backgroundColor = .clear



    }
    //titreşim bas
    func vibrate(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}


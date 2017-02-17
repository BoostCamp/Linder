//
//  JoinViewController.swift
//  
//
//  Created by 박종훈 on 2017. 1. 13..
//
//

import UIKit
import Alamofire
import SwiftyJSON

fileprivate let segueToJoinID = "toJoinSequence"
fileprivate let segueToMainID = "toMain"

class JoinViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passCheckField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let userDC = UserDataController.shared
    
    var isSamePassword: Bool {
        return (passwordField.text == passCheckField.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donebuttonTouchUpInside(_ sender: Any) {
        guard let email = emailField.text, email != "" else {
            return self.showEmailAlert()
        }
        guard let password = passwordField.text, password != "" else {
            return self.showPasswordAlert()
        }
        guard let name = nameField.text, name != "" else {
            return self.showNameAlert()
        }
        
        if isSamePassword {
            join(name: name, email: email, password: password)
        } else {
            // TOOD : show different Password alert
            self.errorLabel.text = "not same Password"
        }
    }
    
    @IBAction func moveToMain(segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEmailAlert() {
        // TODO : showEmailAlert
        emailField.text = "empty"
    }

    func showPasswordAlert() {
        // TODO : showPasswordAlert
        passwordField.text = "empty"
    }

    func showNameAlert() {
        // TODO : showNameAlert
        nameField.text = "empty"
    }
    
    func join(name: String, email: String, password: String) {
        //debugPrint("baseURL: ", baseURL)
        let path = baseURL + "users"
        debugPrint("path: ", path)
        let calPlatform: [String:String?] = ["name" : nil]
        
        let body: Parameters = [
            "name": name,
            "email": email,
            "password": password,
            "platform": calPlatform
        ]
        // TODO : save body for when post fail to retry
        
        Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value) :
                // get userId from json
                let valueJSON = JSON(value)
                let dataJSON = valueJSON["data"]
                // set userId from UserDC
                self.userDC.user.id = dataJSON["uid"].int64Value
                print("Join Success, UserID: ", self.userDC.user.id)
                
                self.acquireToken(username: email, password: password)
            case .failure(let error) :
                debugPrint("Response:")
                debugPrint(response)
                // TODO : catch error
                // TODO : add retry task using saved body to task queue
                print(error)
                self.errorLabel.text = "Join Fail. Retry"
            }
        })

    }
    
    func acquireToken(username: String, password: String) {
        // Acquire Token
        let path = baseURL + "oauth/token?client_id=native-application&grant_type=password&username="+username+"&password="+password
        Alamofire.request(path, method: .post).validate().responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success(let value) :
                // get token data from json
                let valueJSON = JSON(value)
                let accessToken = valueJSON["access_token"].stringValue
                //let tokenType = valueJSON["token_type"].stringValue  // always "beare"
                let refreshToken = valueJSON["refresh_token"].stringValue
                let expiresIn = valueJSON["expires_in"].intValue
                
                // set token data from json to AppDelegate's User property
                
                self.userDC.user.setToken(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
            
                print("Token Acquiring Success. AccessToken: ", self.userDC.user.accessToken!)
                print("ID: ", username)
                print("PW: ", password)
                // show join sequences
                self.performSegue(withIdentifier: segueToJoinID, sender: self)
            case .failure :
                debugPrint("Response:")
                debugPrint(response)
                // TODO : catch error
                self.errorLabel.text = "Token Acquiring Fail. Retry"
            }

        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  Okta-Login
//
//  Created by Steven Barash on 2/6/20.
//  Copyright © 2020 Steven Barash. All rights reserved.
//

import UIKit
import OktaAuth
import AppAuth

class ViewController: UIViewController {
    var currentLoginToken: String? = ""
    
    var currentserName : String? = ""
    
    var observer:NSKeyValueObservation?
    

    @IBOutlet weak var localeLabel: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var accessTokenLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var loginTokenLabel: UILabel!
    

    @IBAction func logoutPressed(_ sender: Any) {
        
        //when pressed, clears stored tokens, cookies of webview browser
//        and resets UI to logged out state

        

        OktaAuth.tokens?.clear()
        currentLoginToken =  OktaAuth.tokens?.idToken!
        if(currentLoginToken == nil){
            loginTokenLabel.text = ("ID Token: \(currentLoginToken)")

        }
        else{
            loginTokenLabel.text = ("ID Token: \(currentLoginToken!)")

        }
        currentserName = ""
        localeLabel.text = ""
        

        logInButton.isHidden = false
        logOutButton.isHidden = true
        welcomeMessage.text = "Log out succesful"
        
    }
    
    func setUserInfo(name:String,loginToken:String, locale:String){
        
        //change welcome message based on locality
        localeLabel.text = "Locale: \(locale)"
        
        print(locale)
        
        
        if(locale == "ru-RU"){
            self.welcomeMessage.text = ("Привет, \(name)" )

        }
        else{
            self.welcomeMessage.text = ("Welcome, \(name)" )

            
        }
        
//        if(currentLoginToken != nil){
//            currentLoginToken = loginToken!
//
//        }
//        else{
            currentLoginToken = loginToken

//        }
        self.loginTokenLabel.text = ("ID Token: \(String(describing: currentLoginToken!))")
//        self.emailLabel.text = email
        

    }

    
    @IBAction func loginPressed(_ sender: Any) {
        
        //awaits response from web login, sets tokens accordingly, sets UI elements accordingly
        OktaAuth
            .login()
            .start(self) { response, error in
                if error != nil { print(error!) }

                // Success
                if let tokenResponse = response {
                    OktaAuth.tokens?.set(value: tokenResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value:
                        tokenResponse.idToken!, forKey: "idToken")

                    OktaAuth.userinfo(){
                        response, error in
                        if error != nil {print("Error:\(error!)")}

                        if let userinfo = response{
                            DispatchQueue.main.async {
                                self.logOutButton.isHidden = false

                                self.logInButton.isHidden = true
                                
                                print(userinfo)
                                
                                self.setUserInfo(name: userinfo["name"] as! String,loginToken: tokenResponse.idToken!, locale: userinfo["locale"] as! String)
                                
                                //                            userinfo["email"]

                            }

                        }
                    }
                }


                }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        }


}


//
//  ViewController.swift
//  Where Am I
//
//  Created by Romain Rivollier on 23/12/14.
//  Copyright (c) 2014 Romain Rivollier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func WhereAmITap(sender: AnyObject) {
        
        self.textView.text = nil;
        
        WhereAmI.sharedInstance.whereAmI({ (location) -> Void in
            
            self.textView.text = location.description;
            
            }, locationRefusedHandler: { [unowned self] (locationIsAuthorized) -> Void in
                
                if (!locationIsAuthorized) {
                    self.showAlertView();
                }
        });
        
    }
    @IBAction func WhatIsThisPlaceTap(sender: AnyObject) {
        
        self.textView.text = nil;
        
        WhereAmI.sharedInstance.whatIsThisPlace({ (placemark) -> Void in
            
            if (placemark != nil) {
                self.textView.text = "\(placemark.name) \(placemark.locality) \(placemark.country)";
            }
            
            }, locationRefusedHandler: {[unowned self] (locationIsAuthorized) -> Void in
                
                if (!locationIsAuthorized) {
                    self.showAlertView();
                }
        });
        
    }
    
    func fullControlWay() {

        if (!WhereAmI.userHasBeenPromptedForLocationUse()) {
            
            WhereAmI.sharedInstance.askLocationAuthorization({ [unowned self](locationIsAuthorized) -> Void in
               
                if (!locationIsAuthorized) {
                    self.showAlertView();
                } else {
                    self.startLocationUpdate();
                }
            });
        }
        else if (!WhereAmI.locationIsAuthorized()) {
            self.showAlertView();
        }
        else {
            self.startLocationUpdate();
        }
    }
    
    private func startLocationUpdate() {
        
        WhereAmI.sharedInstance.continuousUpdate = true;
        WhereAmI.sharedInstance.startUpdatingLocation({ (location) -> Void in
            
        });
    }
    
    func showAlertView() {
        
        var alertView = UIAlertView(title: "Location Refused",
                                    message: "The app is not allowed to retreive your current location",
                                    delegate: nil,
                                    cancelButtonTitle: "OK");
        
        alertView.show();
    }
}


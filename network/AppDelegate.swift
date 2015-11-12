//
//  AppDelegate.swift
//  network
//
//  Created by tauCross on 15/11/11.
//  Copyright © 2015年 tauCross. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var GETButton: NSButton!
    @IBOutlet weak var POSTButton: NSButton!
    @IBOutlet weak var bodyLabel: NSTextField!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var URLBox: NSTextField!
    @IBOutlet weak var bodyBox: NSTextField!
    @IBOutlet var responseBox: NSTextView!
    @IBAction func sentAction(sender: AnyObject) {
        sendAction(sender)
    }

    var session : NSURLSession!
    
    func resetMethod(){
        GETButton.state = 0
        POSTButton.state = 0
        bodyLabel.hidden = true
        bodyBox.hidden = true
    }
    
    func currentMethod() -> NSString{
        if GETButton.state == 1
        {
            return "GET"
        }
        if POSTButton.state == 1
        {
            return "POST"
        }
        return ""
    }
    
    @IBAction func GETAction(sender: AnyObject) {
        resetMethod()
        GETButton.state = 1
    }
    
    @IBAction func POSTAction(sender: AnyObject) {
        resetMethod()
        POSTButton.state = 1
        bodyBox.hidden = false
        bodyLabel.hidden = false
    }
    
    @IBAction func sendAction(sender: AnyObject) {
        if sendButton.enabled == false
        {
            return
        }
        sendButton.enabled = false
        self.responseBox.string = ""
        let urlString = URLBox.stringValue
        let url = NSURL(string: urlString)
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        if currentMethod() == "GET"
        {
            request.HTTPMethod = "GET"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    if error != nil
                    {
                        self.responseBox.string = (error?.domain)!
                    }
                    else
                    {
                        self.responseBox.string = String(data: data!, encoding: NSUTF8StringEncoding)!
                    }
                    self.sendButton.enabled = true
                })
            })
            task.resume()
        }
        else if currentMethod() == "POST"
        {
            request.HTTPMethod = "POST"
            request.HTTPBody = self.bodyBox.stringValue.dataUsingEncoding(NSUTF8StringEncoding)
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    if error != nil
                    {
                        self.responseBox.string = (error?.domain)!
                    }
                    else
                    {
                        self.responseBox.string = String(data: data!, encoding: NSUTF8StringEncoding)!
                    }
                    self.sendButton.enabled = true
                })
            })
            task.resume()
        }
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Accept" : "application/json", "Content-Type" : "application/json"]
        session = NSURLSession(configuration: config)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}


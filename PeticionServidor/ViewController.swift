//
//  ViewController.swift
//  PeticionServidor
//
//  Created by Josman Pérez Expósito on 05/12/15.
//  Copyright © 2015 personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
  
  @IBOutlet weak var isbnInputText: UITextField!
  @IBOutlet weak var textViewResultado: UITextView?
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  let baseURL = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:")
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    isbnInputText.delegate = self
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Acciones
  
  func textFieldDidEndEditing(textField: UITextField) {
    if (isbnInputText.text?.characters.count > 0) {
      self.spinner.startAnimating()
      if let isbn = isbnInputText.text {
        let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)")
        print(url!)
        let sesion = NSURLSession.sharedSession()
        
        let dt = sesion.dataTaskWithURL(url!) {
          (let datos, let resp, let error) in
          if let httpResponse = resp as? NSHTTPURLResponse {
            switch (httpResponse.statusCode) {
            case 200:
              let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
              print(texto!)
              dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                self.textViewResultado?.text = texto! as String
              }
            default:
              print("El get no fue satisfactorio")
              
            }
          } else {
            dispatch_async(dispatch_get_main_queue()) {
              self.spinner.stopAnimating()
              let alertController = UIAlertController(title: "Error", message:
                "Ha ocurrido un error!", preferredStyle: UIAlertControllerStyle.Alert)
              alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
              
              self.presentViewController(alertController, animated: true, completion: nil)
            }
            
          }
          
        }
        dt.resume()
        
      }
    }
  }
  
  // Ocultar el teclado
  @IBAction func textFieldDoneEditing(sender: UITextField) {
    
    sender.resignFirstResponder()
  }
  
  // Ocultar teclado con toque en la pantalla
  @IBAction func backgroundTap(sender: UIControl) {
    
    isbnInputText.resignFirstResponder()
  }
  
  
  
}


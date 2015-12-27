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
  
  @IBOutlet weak var labelTituloText: UILabel!
  @IBOutlet weak var imagenCover: UIImageView!
  
  @IBOutlet weak var imagenActivityIndicator: UIActivityIndicatorView!
  var imageCache: NSCache?
  
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
    self.imagenCover.hidden = true
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
              var titulo = ""
              var autores = ""
              do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers)
                
                let dico1 = json as! NSDictionary
                if let dico2 = dico1["ISBN:\(isbn)"] as? NSDictionary {
                  let dico3 = dico2["authors"] as? [NSDictionary]
                  titulo = "\(dico2["title"] as! NSString as String)"
                  
                  
                  // Comprobamos que exista portada
                  if let dico4 = dico2["cover"] as? NSDictionary {
                    let url = NSURL(string: dico4["medium"] as! NSString as String)
                    print(url!)
                    self.imagenActivityIndicator.startAnimating()
                    self.imagenActivityIndicator.hidden = false
                    self.load_image(url!)
                  }
                  if let dicAutores = dico3 {
                    for autor in dicAutores {
                      autores += "\(autor["name"] as! NSString as String) "
                    }
                  }
                } else {
                  titulo = "ISBN no válido"
                }
              } catch _ {
                print("Error")
              }
              dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                //self.textViewResultado?.text = texto! as String
                self.labelTituloText.text = titulo
                self.textViewResultado!.text = autores
              }
            default:
              print("El get no fue satisfactorio")
              
            }
          } else {
            dispatch_async(dispatch_get_main_queue()) {
              self.spinner.stopAnimating()
              let alertController = UIAlertController(title: "Error", message:
                "¡Ha ocurrido un error con internet!", preferredStyle: UIAlertControllerStyle.Alert)
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
  
  func load_image(urlString:NSURL) {
    let imgURL = urlString
    let request: NSURLRequest = NSURLRequest(URL: imgURL)
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request){
      (data, response, error) -> Void in
      
      if (error == nil && data != nil)
      {
        func display_image()
        {
          self.imagenCover.image = UIImage(data: data!)
          self.imagenCover.hidden = false
          self.imagenActivityIndicator.hidden = true
          self.imagenActivityIndicator.stopAnimating()
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)
      }
      
    }
    
    task.resume()
  }
  
  
}


//
//  PostViewController.swift
//  QuickSale
//
//  Created by CS on 12/4/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var iNameFeild: UITextField!
    @IBOutlet weak var priceFeild: UITextField!
    @IBOutlet weak var descriptionFeild: UITextView!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iNameFeild.delegate = self
        priceFeild.delegate = self
        descriptionFeild.delegate = self
        let dimissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboard))
        view.addGestureRecognizer(dimissKeyboardGesture)
        
        //TODO: reopen camera when touch the image
        let reopenCamera : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.reopenCamera))
        itemImage.addGestureRecognizer(reopenCamera)

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
    }
    
    //dismiss keyboard when touch outside
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func reopenCamera() {
        present(imagePicker, animated: true, completion: nil)
    }

    //dismiss keyboard on return/done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        iNameFeild.resignFirstResponder()
        priceFeild.resignFirstResponder()
        return true 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(itemImage.image == nil){
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        itemImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        analyzeImage(itemImage.image!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)  
        tabBarController?.selectedIndex = 0
    }

    //analyze and predict the object in the image
    func analyzeImage(_ image: UIImage){
        guard let model = try? VNCoreMLModel (for:Resnet50().model) else {
            print("cannot initialize MLCore")
            return
        }
        
        let request = VNCoreMLRequest(model:model){
            [ weak self]  request, error in
            guard let result = request.results as? [VNClassificationObservation],
                let firstResult = result.first  else{
                    print("Cannot get result from VNCoreMLRequest")
                    return
            }
            
            DispatchQueue.main.async {
                self?.iNameFeild.text = firstResult.identifier
            }
        }
        
        guard let ciImage = CIImage(image:image) else {
            print("cannot convert UIImage to CIImage")
            return
        }
        let handler = VNImageRequestHandler(ciImage:ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try handler.perform([request])
            }catch{
                print("analyzeImage error: \(error)")
            }
        }
        
    }
    
    @IBAction func postAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        tabBarController?.selectedIndex = 0
        itemImage.image = nil
        iNameFeild.text = nil
        priceFeild.text = nil
        descriptionFeild.text = nil
    }
    
}

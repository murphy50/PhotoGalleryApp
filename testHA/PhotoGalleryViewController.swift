//
//  ViewController.swift
//  testHA
//
//  Created by murphy on 25.03.2024.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var frameView: UIView!
    
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.applyBlurEffect()

        // Create frame view
        frameView = UIView(frame: CGRect(x: (view.frame.width - 250) / 2, y: (view.frame.height - 250) / 2, width: 250, height: 250))
        frameView.applyBlurEffect()
       // frameView.backgroundColor = .white
        frameView.layer.borderColor = UIColor.yellow.cgColor
        frameView.layer.borderWidth = 2.0
        frameView.clipsToBounds = true
        
        // Create "+"" button
        let addButton = UIButton(type: .system)
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.frame = CGRect(x: (view.frame.width - 50) / 2, y: (view.frame.height - 50) / 2, width: 50, height: 50)
        
        // Create save button
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("💾", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.frame = CGRect(x: (view.frame.width - 50) / 2, y: view.frame.height - 70, width: 50, height: 50)
        
        // Create image view
        imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.frame = view.frame//CGRect(x: 0, y: 0, width: frameView.frame.width, height: frameView.frame.height)
        
        // Add pan gesture recognizer to image view
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        imageView.addGestureRecognizer(panGesture)
        
        // Add pinch gesture recognizer to image view
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        imageView.addGestureRecognizer(pinchGesture)
        
        // Add views to the hierarchy
        view.addSubview(frameView)
        view.addSubview(addButton)
        view.addSubview(saveButton)
        frameView.addSubview(imageView)
    }

    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        guard let imageView = gesture.view else { return }
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        if gesture.state == .changed {
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            var newScale = currentScale * gesture.scale
            
            // Ограничение размеров
            if newScale < 0.5 {
                newScale = 0.5
            }
            if newScale > 3 {
                newScale = 3
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            imageView.transform = transform
            gesture.scale = 1
        }
    }
    
    @objc func saveButtonTapped() {
        // Ваша логика для сохранения фотографии
    }
    @objc private func addButtonTapped() {
        ImagePickerManager().pickImage(self){ [self] image in
            DispatchQueue.main.async { [self] in
                self.imageView.image = image
                //view.layoutIfNeeded()
            }
              
          }
        }
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
import UIKit


extension UIView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

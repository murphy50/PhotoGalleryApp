//
//  ViewController.swift
//  testHA
//
//  Created by murphy on 25.03.2024.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: PhotoGalleryViewModel!
    private var imageView: UIImageView!
    private var frameView: UIView!
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        setupFrameView()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "💾", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupFrameView() {
        frameView = UIView(frame: CGRect(x: (view.frame.width - 250) / 2, y: (view.frame.height - 400) / 2, width: 250, height: 400))
        frameView.layer.borderColor = UIColor.yellow.cgColor
        frameView.layer.borderWidth = 2.0
        frameView.clipsToBounds = true
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frameView.frame.width, height: frameView.frame.height))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        // Add gestures to imageView
        addGestures()
        
        frameView.addSubview(imageView)
        view.addSubview(frameView)
    }
    
    private func addGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
    }
   
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        viewModel.addButtonAction()
    }
    
    @objc private func saveButtonTapped() {
        guard let clippedImage = clipImage() else { return }
        viewModel.saveButtonAction(clippedImage)
    }
    
    // MARK: - Gesture Handlers
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        if gesture.state == .changed {
            let minScale: CGFloat = 0.5
            let maxScale: CGFloat = 3
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            var newScale = currentScale * gesture.scale
            
            if newScale < minScale {
                newScale = minScale
            }
            if newScale > maxScale {
                newScale = maxScale
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            imageView.transform = transform
            gesture.scale = 1
        }
    }
    
    // MARK: - Image Clipping
    
    private func clipImage() -> UIImage? {
        guard let imageView = imageView, frameView.frame.intersects(imageView.bounds) else {
            return nil
        }
        
        let visibleFrame = frameView.convert(frameView.bounds, to: imageView)
        
        let renderer = UIGraphicsImageRenderer(bounds: visibleFrame)
        let clippedImage = renderer.image { context in
            imageView.layer.render(in: context.cgContext)
        }
        
        return clippedImage
    }
}

extension PhotoGalleryViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        viewModel.setImage(image)
        imageView.image = viewModel.image
        imageView.frame = CGRect(x: -frameView.frame.origin.x, y: -frameView.frame.origin.y, width: view.frame.width, height: view.frame.height)
    }
}

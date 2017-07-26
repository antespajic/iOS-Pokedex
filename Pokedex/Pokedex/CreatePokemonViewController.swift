//
//  CreatePokemonViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 26/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreatePokemonViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var abilitiesSelectField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    let disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        addButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.imagePicker.allowsEditing = false
                self?.imagePicker.sourceType = .photoLibrary
                guard let imPicker = self?.imagePicker else { return }
                self?.present(imPicker, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
}

extension CreatePokemonViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}

extension CreatePokemonViewController: UINavigationControllerDelegate {
    
}

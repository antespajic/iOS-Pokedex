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

final class CreatePokemonViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var abilitiesSelectField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: HomeViewController?
    
    private let disposeBag = DisposeBag()
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
        
        saveButton
            .rx.tap
            .asObservable()
            .flatMap{ [unowned self] _ -> Observable<Pokemon?> in
                guard let name = self.nameTextField.text,
                    let height = self.heightTextField.text,
                    let weight = self.weightTextField.text,
                    let type = self.typeTextField.text,
                    //let abilities = self?.abilitiesSelectField.text,
                    let description = self.descriptionTextField.text
                    else { return Observable.just(nil) }
                
                return PokemonService.createPokemon(name: name,
                                                    height: height,
                                                    weight: weight,
                                                    type: type,
                                                    description: description,
                                                    pokemonImage: self.imageView?.image)
            }
            .subscribe (onNext: { [unowned self] response in
                        guard let createdPokemon = response else { return }
                        self.delegate?.addNewPokemon(createdPokemon)
                        self.navigationController?.popViewController(animated: true)
            }, onError:{ error in
                    print(error)
            })
            .disposed(by: disposeBag)
        
        registerKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 15, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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

import UIKit
import DropDown
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Photos
import PromiseKit
import MaterialComponents
import SwiftValidator
import SwiftSVG

class CreatePostViewController: UIViewController, MDCMultilineTextInputDelegate {
    let MAX_SUBJECT_LENGTH = 300
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBAction func cancelPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPost(_ sender: Any) {
        self.validator.validate(self)
    }
    
    let keyboardMenuAccessory: UIView = {
        let accessoryView = UIView(frame: .zero)
        accessoryView.backgroundColor = .lightGray
        accessoryView.alpha = 0.6
        return accessoryView
    }()
    
    let openKeyboardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        var cameraImg = UIImage(systemName: "keyboard")
        cameraImg = cameraImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        button.setImage(cameraImg, for: .normal)
        button.addTarget(self, action:
        #selector(keyboardBtnTapped), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    
    let openPhotoGalleryBtn: UIButton! = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        var cameraImg = UIImage(systemName: "photo.on.rectangle")
        cameraImg = cameraImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        button.setImage(cameraImg, for: .normal)
        button.addTarget(self, action:
        #selector(openPhotoGallery), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let openCameraBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        var cameraImg = UIImage(systemName: "camera")
        cameraImg = cameraImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        button.setImage(cameraImg, for: .normal)
        button.addTarget(self, action:
        #selector(openCamera), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let workoutTypeDropDown: DropDown = {
        let dropdown = DropDown()
        return dropdown
    }()
    
    let chevronUp: UIImageView
    let chevronDown: UIImageView
    
    let workoutTypeTextField: MDCTextField = {
        let field = MDCTextField()
        field.placeholder = "Select Workout Type"
        field.cursorColor = .none
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let workoutTypeTextFieldController: MDCTextInputControllerFilled
    
    let subjectTextField: MDCTextField = {
        let field = MDCTextField()
        field.placeholder = "Title"
        field.keyboardType = .alphabet
        field.returnKeyType = .next
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let subjectTextFieldController: MDCTextInputControllerFilled
    
    let bodyTextField: MDCMultilineTextField = {
        let field = MDCMultilineTextField()
        field.placeholder = "Description"
        field.clearButtonMode = .never
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let bodyTextFieldController: MDCTextInputControllerOutlinedTextArea
    let validator: Validator
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var imagePickerController = UIImagePickerController()
    var isImageChanged = false
    
    static func create() -> CreatePostViewController  {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let createPostViewController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.CreatePostViewControllerId) as! CreatePostViewController
                    
        return createPostViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.subjectTextFieldController = MDCTextInputControllerFilled(textInput: subjectTextField)
        self.subjectTextFieldController.applyTheme(withScheme: ApplicationScheme.instance.containerScheme)
        self.subjectTextFieldController.characterCountViewMode = .always
        self.subjectTextFieldController.characterCountMax = UInt(MAX_SUBJECT_LENGTH)
        self.subjectTextFieldController.floatingPlaceholderNormalColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.subjectTextFieldController.normalColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.subjectTextFieldController.activeColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.subjectTextFieldController.inlinePlaceholderColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.subjectTextFieldController.floatingPlaceholderActiveColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.subjectTextFieldController.trailingUnderlineLabelTextColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        
        self.bodyTextFieldController = MDCTextInputControllerOutlinedTextArea(textInput: bodyTextField)
         MDCTextFieldTypographyThemer.applyTypographyScheme(ApplicationScheme.instance.containerScheme.typographyScheme, to: self.bodyTextFieldController)
        self.bodyTextFieldController.errorColor = ApplicationScheme.instance.containerScheme.colorScheme.errorColor
        self.bodyTextFieldController.activeColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.bodyTextFieldController.normalColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.bodyTextFieldController.floatingPlaceholderNormalColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.bodyTextFieldController.floatingPlaceholderActiveColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        self.bodyTextFieldController.inlinePlaceholderColor = ApplicationScheme.instance.containerScheme.colorScheme.onBackgroundColor
        
        self.workoutTypeTextFieldController = MDCTextInputControllerFilled(textInput: workoutTypeTextField)
        self.workoutTypeTextFieldController.applyTheme(withScheme: ApplicationScheme.instance.containerScheme)
        self.workoutTypeTextFieldController.isFloatingEnabled = false
        
        self.chevronUp = UIImageView(SVGNamed: "chevron-up") {
            (svgLayer) in
            svgLayer.fillColor = .none
            svgLayer.strokeColor = UIColor.white.cgColor
        }
        
        self.chevronDown = UIImageView(SVGNamed: "chevron-down"){
            (svgLayer) in
            svgLayer.fillColor = .none
            svgLayer.strokeColor = UIColor.white.cgColor
        }
        
        self.validator = Validator()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDropDown()
        initTextViewPlaceholders()
        initActivityIndicator()
        photoImageView.isHidden = true //photo appears and to adjusted height once uploaded
        photoHeightConstraint.constant = 0
        addKeyboardMenuAccessory()
        setupValidation()
    }    
}

extension CreatePostViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       
       isImageChanged = true
       photoImageView.isHidden = false //photo appears and to adjusted height once uploaded
       photoHeightConstraint.constant = 200
       photoImageView.image = chosenImage
       
       imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension CreatePostViewController: ValidationDelegate {
    func validationSuccessful() {
        self.postButton.isEnabled = false
        
        self.subjectTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
        self.bodyTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
        self.workoutTypeTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
        
        submitPostWorkflow()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? MDCTextField {
                if field == self.subjectTextField {
                    self.subjectTextFieldController.setErrorText(error.errorMessage, errorAccessibilityValue: error.errorMessage)
                }
                else if field == self.workoutTypeTextField {
                    self.workoutTypeTextFieldController.setErrorText(error.errorMessage, errorAccessibilityValue: error.errorMessage)
                }
            }
            else if let field = field as? MDCIntrinsicHeightTextView {
                if field == self.bodyTextField.textView! {
                    self.bodyTextFieldController.setErrorText(error.errorMessage, errorAccessibilityValue: error.errorMessage)
                }
            }
        }
    }
    
    private func setupValidation() {
        validator.registerField(self.subjectTextField, rules: [RequiredRule(message: "Required")])
        validator.registerField(self.bodyTextField.textView!, rules: [RequiredRule(message: "Required")])
        validator.registerField(self.workoutTypeTextField, rules: [RequiredRule(message: "Required")])
    }
}

extension CreatePostViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField as? MDCTextField == self.workoutTypeTextField {
            if self.workoutTypeDropDown.isHidden {
                self.workoutTypeDropDown.show()
            } else {
                self.workoutTypeDropDown.hide()
            }
            self.toggleWorkoutTypeIcon()
            return false
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField as? MDCTextField == self.subjectTextField && self.subjectTextFieldController.errorText != nil {
            self.subjectTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validator.validateField(textField) { error in
            if textField as? MDCTextField == self.subjectTextField {
                self.bodyTextField.becomeFirstResponder()
                self.subjectTextFieldController.setErrorText(error?.errorMessage, errorAccessibilityValue: error?.errorMessage)
            }
        }
        
        return true
    }
}

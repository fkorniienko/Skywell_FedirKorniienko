//
//  AddCarViewController.swift
//  
//
//  Created by Fedir Korniienko on 03.06.17.
//
//

protocol PickerDelegate {
    func donePicker(sender:UIBarButtonItem)
    func cancelPicker(sender:UIBarButtonItem)
}

import UIKit

class AddCarViewController: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIPickerViewDelegate, UIPickerViewDataSource, PickerDelegate, UITextFieldDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldCarName: UITextField!
    @IBOutlet weak var textFieldCarCost: UITextField!
    @IBOutlet weak var textFieldEngine: UITextField!
    @IBOutlet weak var textFieldTransmission: UITextField!
    @IBOutlet weak var textFieldCondition: UITextField!
    @IBOutlet weak var labelStaticCar: UILabel!
    @IBOutlet weak var labelStaticPrice: UILabel!
    
    var id: String?
    let pickerView = UIPickerView()
    var pickerItems = [String]()
    
    let pickerName = ["BMW", "Honda", "Audi"]
    let pickerCost = ["10000$", "20000$", "30000$", "50000$"]
    let pickerEngine = ["1.0i.e","2.0i.e","3.0i.e","4.0i.e","5.0i.e","6.0i.e","7.0i.e"]
    let pickerTransmission = [NSLocalizedString("manual", comment: ""), NSLocalizedString("auto", comment: "")]
    let pickerCondition = [NSLocalizedString("new", comment: ""), NSLocalizedString("good", comment: ""), NSLocalizedString("old", comment: "")]
    var imageData = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: "AddCarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddCarCollectionViewCell")
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_icon"), style: .done, target: self, action: #selector(addCar))
        setup()
    }
    func setup(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        textFieldCarName.inputView = pickerView
        textFieldCarCost.inputView = pickerView
        textFieldEngine.inputView = pickerView
        textFieldTransmission.inputView = pickerView
        textFieldCondition.inputView = pickerView
        
        textFieldCarName.delegate = self
        textFieldCarCost.delegate = self
        textFieldEngine.delegate = self
        textFieldTransmission.delegate = self
        textFieldCondition.delegate = self
        
        textFieldCarName.inputAccessoryView = createPickerToolbar()
        textFieldCarCost.inputAccessoryView = createPickerToolbar()
        textFieldEngine.inputAccessoryView = createPickerToolbar()
        textFieldTransmission.inputAccessoryView = createPickerToolbar()
        textFieldCondition.inputAccessoryView = createPickerToolbar()
        labelStaticPrice.text = NSLocalizedString("price", comment: "")
        labelStaticCar.text = NSLocalizedString("car", comment: "")
        textFieldEngine.text = NSLocalizedString("Engine: ", comment: "")
        textFieldTransmission.text = NSLocalizedString("Transmission: ", comment: "")
        textFieldCondition.text = NSLocalizedString("condition: ", comment: "")

    }
    
    func addCar(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            let carData = CarData(context: context)
            carData.carModel = self.textFieldCarName.text!
            carData.price = self.textFieldCarCost.text!
            carData.engine = self.textFieldEngine.text!
            carData.transmission = self.textFieldTransmission.text!
            carData.condition = self.textFieldCondition.text!
            if self.imageData.count > 0{
            carData.image = self.imageData as NSObject
            }
            carData.id = id!
            try! context.save()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFieldCarName: pickerItems = pickerName
        case textFieldCarCost: pickerItems = pickerCost
        case textFieldEngine: pickerItems = pickerEngine
        case textFieldTransmission: pickerItems = pickerTransmission
        case textFieldCondition: pickerItems = pickerCondition
        default:
            break
        }
        
        pickerView.reloadAllComponents()
    }
    
    // MARK: - Picker delegate

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        updateTextFieldWithPickerValue(row: row)
    }
    
    func updateTextFieldWithPickerValue(row: Int) {
        if pickerItems == pickerName{
        textFieldCarName.text = pickerItems[row]
        }
        if pickerItems == pickerCost{
            textFieldCarCost.text = pickerItems[row]
        }
        if pickerItems == pickerEngine{
            textFieldEngine.text = NSLocalizedString("Engine: ", comment: "") + pickerItems[row]
        }
        if pickerItems == pickerTransmission{
            textFieldTransmission.text = NSLocalizedString("Transmission: ", comment: "") + pickerItems[row]
        }
        if pickerItems == pickerCondition{
            textFieldCondition.text = NSLocalizedString("condition: ", comment: "") + pickerItems[row]
        }
    }
    override func donePicker (sender:UIBarButtonItem){
        self.dismissKeyboard()
    }
    
    override func cancelPicker (sender:UIBarButtonItem){
        self.dismissKeyboard()
    }

    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < imageData.count{
            if let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
                cell.image.image = #imageLiteral(resourceName: "car")
                return cell
            }
        }else{
        if let cell: AddCarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "AddCarCollectionViewCell", for: indexPath) as? AddCarCollectionViewCell {
            
            return cell
        }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height*0.8, height: collectionView.frame.size.height*0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imageData.count  {
        imageData.append(#imageLiteral(resourceName: "car"))
        collectionView.reloadData()
        }
    }
}

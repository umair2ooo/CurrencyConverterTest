import UIKit

class VC_home: VC_base {

    @IBOutlet weak var tf_from: UITextField! {didSet { self.tf_from.inputView = self.picker}}
    @IBOutlet weak var tf_to: UITextField! {didSet {self.tf_to.inputView = self.picker}}
    @IBOutlet weak var tf_fromInput: UITextField! {
        didSet { tf_fromInput.addTarget(self, action: #selector(VC_home.textFieldDidChange(_:)), for: .editingChanged) }
    }
    @IBOutlet weak var tf_toInput: UITextField! {
        didSet { tf_toInput.addTarget(self, action: #selector(VC_home.textFieldDidChange(_:)), for: .editingChanged) }
    }
    
    private var vm : CurrencyConversionProtocol?
    private var isFirst = true
    private var picker : UIPickerView {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm = VM_currencyConversion(uidelegate: self, errorDelegate: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func action_swap(_ sender: Any) {
        self.swap()
    }
    
    @IBAction func action_details(_ sender: Any) {
        self.vm?.showHistory()
    }
    
    private func swap() {
        guard let rowFrom = self.tf_from.getPicker?.selectedRow(inComponent: 0),
              let rowTo = self.tf_to.getPicker?.selectedRow(inComponent: 0) else { return }
        
        self.tf_to.getPicker?.selectRow(rowFrom, inComponent: 0, animated: false)
        self.tf_from.getPicker?.selectRow(rowTo, inComponent: 0, animated: false)
        self.tf_to.text = self.vm?.getCurrency(index: rowFrom)
        self.tf_from.text = self.vm?.getCurrency(index: rowTo)
        
        self.vm?.valueSwaped()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VC_master, let rates = sender as? HistoricalRates {
            vc.history = rates
        }
    }
}


//MARK: - UITextFieldDelegate
extension VC_home : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.isFirst = (textField == self.tf_from) || (textField == self.tf_fromInput)
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.vm?.updateCurrencyOrAmount(currency: textField.text ?? "", isFirst_head: self.isFirst, isCurrency: false)
    }
}


//MARK: - UIPickerViewDataSource
extension VC_home : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return self.vm?.currenciesCount ?? 0}
}


//MARK: - UIPickerViewDelegate
extension VC_home : UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.vm!.getCurrency(index: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.vm!.currenciesCount > 0 {
            self.vm?.updateCurrencyOrAmount(currency: self.vm!.getCurrency(index: row), isFirst_head: self.isFirst, isCurrency: true)
        }
    }
}



//MARK: - ResponderProtocol
extension VC_home : ResponderProtocol {
    
    func getValuesOfPickerAndTF(isFirst_head: Bool) -> [(currency : String?, amount : String?)] {
        
        if isFirst_head {
            return [(self.tf_from.text, self.tf_fromInput.text), (self.tf_to.text, self.tf_toInput.text)]
        }
        else {
            return [(self.tf_to.text, self.tf_toInput.text), (self.tf_from.text, self.tf_fromInput.text)]
        }
    }
    
    
    func fillPickerInitial(currencyFirst: Int, currencySecond: Int, firstText: String?, secondText: String?) {
        self.tf_from.getPicker?.selectRow(currencyFirst, inComponent: 0, animated: false)
        self.tf_to.getPicker?.selectRow(currencySecond, inComponent: 0, animated: false)
        self.tf_from.text = firstText
        self.tf_to.text = secondText
    }
    
    
    func updateText(string: String, isFirst_head: Bool) {
        isFirst_head ? (self.tf_from.text = string) : (self.tf_to.text = string)
    }
    
    
    func currencyResult(amount: String, isFirst_head: Bool) {
        
        if let text = self.tf_toInput.text, text.isEmpty {
            self.tf_toInput.text = amount
            return
        }
        
        if let text = self.tf_fromInput.text, text.isEmpty {
            self.tf_fromInput.text = amount
            return
        }
        
        isFirst_head ? (self.tf_toInput.text = amount) : (self.tf_fromInput.text = amount)
    }
    
    func clearAllAmounts() {
        self.tf_fromInput.text = nil
        self.tf_toInput.text = nil
    }
    
    
    func historicalRates(rates: HistoricalRatesProtocol) {
        self.performSegue(withIdentifier: "segue_showHistory", sender: rates)
    }
}


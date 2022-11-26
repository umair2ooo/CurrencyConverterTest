import Foundation


struct PickerSelectedValue {
    var currency : String?
    var amount : String?
}


class VM_home {
    
    private let uidelegate : ResponderProtocol
    
    private var isFirst_head = true
    
    var dic : [String : PickerSelectedValue] = [:]
    
    private static let from = "from"
    private static let to = "to"
    
    
    private (set) var currencies : [String] = [] {
        didSet {
            if currencies.count > 0 {
                let currency = currencies[0]
                self.uidelegate.fillPickerInitial(currencyFirst: 0,
                                           currencySecond: 0,
                                           firstText: currency,
                                           secondText: currency,
                                           isSwape: false)
            }
        }
    }
    
    init(uidelegate : ResponderProtocol) {
        
        self.uidelegate = uidelegate
        //        self.fetchSymbols()

#warning("uncomment karna hai")
        
        defer {
            self.currencies = ["CAD", "SLL", "PGK", "BAM", "MZN", "KGS", "BDT", "HNL", "SDG", "BSD", "MUR", "ALL", "GTQ", "ZMW", "GBP", "TND", "MKD", "GGP", "DJF", "MDL", "PKR", "BOB", "AED", "GIP", "INR", "MNT", "SEK", "ISK", "SCR", "NIO", "ARS", "LBP", "TOP", "BIF", "ETB", "ANG", "CLP", "LKR", "CRC", "TTD", "SGD", "PAB", "AFN", "GEL", "MYR", "ZWL", "STD", "CUC", "MRO", "JOD", "FJD", "AUD", "NZD", "XPF", "ZAR", "COP", "IDR", "NOK", "KES", "HUF", "PLN", "KYD", "LAK", "RON", "SRD", "MXN", "XCD", "KZT", "SVC", "TMT", "SAR", "CUP", "BTN", "UZS", "BMD", "IMP", "EUR", "NAD", "MAD", "THB", "MVR", "BYR", "RWF", "BWP", "AOA", "VUV", "TZS", "PHP", "EGP", "BRL", "ILS", "TJS", "MWK", "GHS", "HKD", "IRR", "LYD", "GMD", "GYD", "LVL", "AZN", "SLE", "OMR", "SHP", "MOP", "BZD", "BYN", "BBD", "CHF", "DOP", "MMK", "RSD", "XOF", "ERN", "TWD", "BTC", "WST", "XDR", "SYP", "XAU", "QAR", "BHD", "HTG", "FKP", "CDF", "NGN", "UGX", "KHR", "PYG", "UYU", "JPY", "YER", "CZK", "AWG", "VEF", "HRK", "LRD", "XAG", "BND", "SZL", "BGN", "XAF", "CNY", "KMF", "USD", "LTL", "VND", "KWD", "JMD", "SOS", "RUB", "CLF", "UAH", "DZD", "AMD", "MGA", "JEP", "KRW", "LSL", "SBD", "ZMK", "PEN", "TRY", "IQD", "GNF", "CVE", "DKK", "KPW", "NPR"].sorted()
        }
    }


    private func showErrorIfExists(error: String?, success : ()->()) {
        
        guard let error = error else {
            success()
            return
        }
        self.uidelegate.showError(message: error)
    }
}


//MARK: - CalculateConversionProtocol
extension VM_home : CalculateConversionProtocol {
    
    func valuesSwapped() {
        self.grabValues()
    }
    
    
    func calculate() {
        self.exchangeRate()
    }
}



//MARK: - UpdateVM
extension VM_home : UpdateVM {
    
    
    private func grabValues() {
        let array = self.uidelegate.getValuesOfPickerAndTF(isFirst_head: self.isFirst_head)
        
        //It means, all fields are filled, now it will work on the basis of Head pointer
        if (array.filter({($0.currency ?? "").isEmpty}).count == 0) &&
            (array.filter({($0.amount ?? "").isEmpty}).count == 0) {
            
            self.dic[VM_home.from] = PickerSelectedValue(currency: array[0].currency, amount: array[0].amount)
            self.dic[VM_home.to] = PickerSelectedValue(currency: array[1].currency, amount: array[1].amount)
            
            self.calculate()
        }
        
        //If both currencies are selected, and 1 amount has already entered
        else {
            if (array.filter({($0.currency ?? "").isEmpty}).count == 0) {
                
                if !(array.filter({($0.amount ?? "").isEmpty}).count == 2) {
                    if let idx = array.firstIndex(where: {($0.amount ?? "").count > 0 }) {
                        
                        self.dic[VM_home.from] = PickerSelectedValue(currency: array[idx].currency, amount: array[idx].amount)
                        
                        if let idx = array.firstIndex(where: {($0.amount ?? "").isEmpty }) {
                            self.dic[VM_home.to] = PickerSelectedValue(currency: array[idx].currency, amount: nil)
                            self.calculate()
                        }
                    }
                }
            }
        }
    }
    
    
    func updateValueForPicker(currency: String, isFirst_head: Bool) {
        self.isFirst_head = isFirst_head
        if !currency.isEmpty {
            self.uidelegate.updateText(string: currency, isFirst_head: self.isFirst_head)
            self.grabValues()
        }
    }
    
    func updateCurrentAmout(amount: String, isFirst_head: Bool) {
        self.isFirst_head = isFirst_head
        if !amount.isEmpty { self.grabValues() }
        else {
            URLSession.shared.cancelTaskWithUrl(shouldCancelAll: true)
            self.uidelegate.clearAllAmounts()}
    }
}



//MARK: - fetch data
extension VM_home {
    
    private func fetchSymbols() {
        
        WebServices.symbols { [weak self] array, error in
            
            guard let self = self else { return }
            self.showErrorIfExists(error: error) {
                print("array.symbolsArray : \(array!.symbolsArray)")
                self.currencies = array!.symbolsArray.sorted()
            }
        }
    }
    
    
    private func exchangeRate() {
        
        
        // When at-least 3 fields are filled, then fetch data
        guard let fromCurrency = self.dic[VM_home.from]?.currency,
              fromCurrency.count > 0,
              let toCurrency = self.dic[VM_home.to]?.currency,
              toCurrency.count > 0,
              let amount = self.dic[VM_home.from]?.amount,
              amount.count > 0 else { return }
        
        
        print("fromCurrency : \(fromCurrency)")
        print("toCurrency : \(toCurrency)")
        print("amount : \(amount)")
        
        self.saveCurrencies()
        
        self.uidelegate.currencyResult(amount: String(Int.random(in: 1...600)) , isFirst_head: self.isFirst_head)


        /*
        WebServices.exchangeRate(from: fromCurrency,
                                 to: toCurrency,
                                 amount: Double(amount)!) { [weak self] convertedValueModel, error in
            guard let self = self else { return }
            
            self.showErrorIfExists(error: error) {
                if let convertedValueModel = convertedValueModel {
                    print("convertedValueModel : \(convertedValueModel)")
                    self.uidelegate.currencyResult(amount: convertedValueModel.description, isFirst_head: self.isFirst_head)
                }
            }
        }
        */
    }
    
    
    private func saveCurrencies() {
        let currencies = self.dic.values.compactMap({$0.currency})
        UserDefaults.standard.setCurrencies(values: currencies)
    }
}

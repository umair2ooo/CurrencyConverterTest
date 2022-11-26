import Foundation


struct PickerSelectedValue {
    var currency : String?
    var amount : String?
}


class VM_currencyConversion {
    
    private let uidelegate : ResponderProtocol
    private let errorDelegate : ShowErrorProtocol?
    
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
                                           secondText: currency)
            }
        }
    }
    
    init(uidelegate : ResponderProtocol, errorDelegate : ShowErrorProtocol?) {
        
        self.uidelegate = uidelegate
        self.errorDelegate = errorDelegate
        self.fetchSymbols()

        /*
#warning("uncomment karna hai")
        
        defer {
            self.currencies = ["CAD", "SLL", "PGK", "BAM", "MZN", "KGS", "BDT", "HNL", "SDG", "BSD", "MUR", "ALL", "GTQ", "ZMW", "GBP", "TND", "MKD", "GGP", "DJF", "MDL", "PKR", "BOB", "AED", "GIP", "INR", "MNT", "SEK", "ISK", "SCR", "NIO", "ARS", "LBP", "TOP", "BIF", "ETB", "ANG", "CLP", "LKR", "CRC", "TTD", "SGD", "PAB", "AFN", "GEL", "MYR", "ZWL", "STD", "CUC", "MRO", "JOD", "FJD", "AUD", "NZD", "XPF", "ZAR", "COP", "IDR", "NOK", "KES", "HUF", "PLN", "KYD", "LAK", "RON", "SRD", "MXN", "XCD", "KZT", "SVC", "TMT", "SAR", "CUP", "BTN", "UZS", "BMD", "IMP", "EUR", "NAD", "MAD", "THB", "MVR", "BYR", "RWF", "BWP", "AOA", "VUV", "TZS", "PHP", "EGP", "BRL", "ILS", "TJS", "MWK", "GHS", "HKD", "IRR", "LYD", "GMD", "GYD", "LVL", "AZN", "SLE", "OMR", "SHP", "MOP", "BZD", "BYN", "BBD", "CHF", "DOP", "MMK", "RSD", "XOF", "ERN", "TWD", "BTC", "WST", "XDR", "SYP", "XAU", "QAR", "BHD", "HTG", "FKP", "CDF", "NGN", "UGX", "KHR", "PYG", "UYU", "JPY", "YER", "CZK", "AWG", "VEF", "HRK", "LRD", "XAG", "BND", "SZL", "BGN", "XAF", "CNY", "KMF", "USD", "LTL", "VND", "KWD", "JMD", "SOS", "RUB", "CLF", "UAH", "DZD", "AMD", "MGA", "JEP", "KRW", "LSL", "SBD", "ZMK", "PEN", "TRY", "IQD", "GNF", "CVE", "DKK", "KPW", "NPR"].sorted()
        }
        */
    }
}


//MARK: - CalculateConversionProtocol
extension VM_currencyConversion : CalculateConversionProtocol {

    func valuesSwapped() {
        self.grabValues()
    }


    func calculate() {
        self.exchangeRate()
    }
}



//MARK: - UpdateVM
extension VM_currencyConversion : UpdateVM {
    
    
    private func grabValues() {
        let array = self.uidelegate.getValuesOfPickerAndTF(isFirst_head: self.isFirst_head)
        
        //It means, all fields are filled, now it will work on the basis of Head pointer
        if (array.filter({($0.currency ?? "").isEmpty}).count == 0) &&
            (array.filter({($0.amount ?? "").isEmpty}).count == 0) {
            
            self.dic[VM_currencyConversion.from] = PickerSelectedValue(currency: array[0].currency, amount: array[0].amount)
            self.dic[VM_currencyConversion.to] = PickerSelectedValue(currency: array[1].currency, amount: array[1].amount)
            
            self.calculate()
        }
        
        //If both currencies are selected, and 1 amount has already entered
        else {
            if (array.filter({($0.currency ?? "").isEmpty}).count == 0) {
                
                if !(array.filter({($0.amount ?? "").isEmpty}).count == 2) {
                    if let idx = array.firstIndex(where: {($0.amount ?? "").count > 0 }) {
                        
                        self.dic[VM_currencyConversion.from] = PickerSelectedValue(currency: array[idx].currency, amount: array[idx].amount)
                        
                        if let idx = array.firstIndex(where: {($0.amount ?? "").isEmpty }) {
                            self.dic[VM_currencyConversion.to] = PickerSelectedValue(currency: array[idx].currency, amount: nil)
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
            self.uidelegate.clearAllAmounts()
        }
    }
}



//MARK: - fetch data
extension VM_currencyConversion {
    
    private func fetchSymbols() {
        
        WebServices.symbols { [weak self] array, error in
            
            guard let self = self else { return }
            self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
                print("array.symbolsArray : \(array!.symbolsArray)")
                self.currencies = array!.symbolsArray.sorted()
            }
        }
    }
    
    
    private func exchangeRate() {
        
        
        // When at-least 3 fields are filled, then fetch data
        guard let fromCurrency = self.dic[VM_currencyConversion.from]?.currency,
              fromCurrency.count > 0,
              let toCurrency = self.dic[VM_currencyConversion.to]?.currency,
              toCurrency.count > 0,
              let amount = self.dic[VM_currencyConversion.from]?.amount,
              amount.count > 0 else { return }
        
        
        print("fromCurrency : \(fromCurrency)")
        print("toCurrency : \(toCurrency)")
        print("amount : \(amount)")

        
        WebServices.exchangeRate(from: fromCurrency,
                                 to: toCurrency,
                                 amount: Double(amount)!) { [weak self] convertedValueModel, error in
            guard let self = self else { return }
            
            self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
                if let convertedValueModel = convertedValueModel {

                    self.saveCurrencies()
                    self.uidelegate.currencyResult(amount: convertedValueModel.description, isFirst_head: self.isFirst_head)
                }
            }
        }
    }
    
    
    private func saveCurrencies() {
        let currencies = self.dic.values.compactMap({$0.currency})
        UserDefaults.standard.setCurrencies(values: currencies)
    }
    
    
    
    private func historicalRates() {
        
        let baseCurrency = "USD"
        
        guard var currencies = UserDefaults.standard.getCurrencies else { return }
        currencies.removeAll(where: {$0 == baseCurrency})
        let currenciesString = currencies.joined(separator: ",")
        
        let startDate = Helper.calculatedDate(howManyDaysBack: 3)
        let endDate = Helper.calculatedDate(howManyDaysBack: 1)
        
        WebServices.timeseries(startDate: startDate,
                               endDate: endDate,
                               symbols: currenciesString,
                               baseCurrency: baseCurrency) { [weak self] historicalRts, error in
            guard let self = self else { return }
            
            self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
                guard let historicalRts = historicalRts, historicalRts.rates?.count ?? 0 > 0 else {
                    self.errorDelegate?.showError(message: Constants.GeneralConstants.noHistoryRecordFound)
                    return
                }
                self.uidelegate.historicalRates(rates: historicalRts)
            }
        }
    }
}


//MARK: - History
extension VM_currencyConversion : History {
    
    func showHistory() {
        self.historicalRates()
    }
}



//MARK: - CheckErrorExistence
extension VM_currencyConversion : CheckErrorExistence {
    func showErrorIfExists(delegate: ShowErrorProtocol?, error: String?, success: () -> ()) {
        
        guard let error = error else {
            success()
            return
        }
        delegate?.showError(message: error)
    }
}

import Foundation


struct PickerSelectedValue {
    var currency : String?
    var amount : String?
}


class VM_currencyConversion {
    
    private let uidelegate : ResponderProtocol?
    private let errorDelegate : ShowErrorProtocol?
    
    private var isFirst_head = true
    
    private var dic : [String : PickerSelectedValue] = [:]
    
    private static let from = "from"
    private static let to = "to"
    
    private var webManager : FetchAndCalculateCurrency?
    
    private var currencies : [String] = [] {
        didSet {
            if currencies.count > 0 {
                let currency = currencies[0]
                self.uidelegate?.fillPickerInitial(currencyFirst: 0,
                                           currencySecond: 0,
                                           firstText: currency,
                                           secondText: currency)
            }
        }
    }
    
    init(uidelegate : ResponderProtocol?, errorDelegate : ShowErrorProtocol?) {
        
        self.uidelegate = uidelegate
        self.errorDelegate = errorDelegate
        self.webManager = FetchAndCalculateCurrency(delegate: self)

        self.webManager?.symbols()
    }
    
    
    
    private func grabValues() {
        if let array = self.uidelegate?.getValuesOfPickerAndTF(isFirst_head: self.isFirst_head) {
            
            //It means, all fields are filled, now it will work on the basis of Head pointer
            if (array.filter({($0.currency ?? "").isEmpty}).count == 0) &&
                (array.filter({($0.amount ?? "").isEmpty}).count == 0) {
                
                self.dic[VM_currencyConversion.from] = PickerSelectedValue(currency: array[0].currency, amount: array[0].amount)
                self.dic[VM_currencyConversion.to] = PickerSelectedValue(currency: array[1].currency, amount: array[1].amount)

                self.exchangeRate()
            }
            
            //If both currencies are selected, and 1 amount has already entered
            else {
                if (array.filter({($0.currency ?? "").isEmpty}).count == 0) {
                    
                    if !(array.filter({($0.amount ?? "").isEmpty}).count == 2) {
                        if let idx = array.firstIndex(where: {($0.amount ?? "").count > 0 }) {
                            
                            self.dic[VM_currencyConversion.from] = PickerSelectedValue(currency: array[idx].currency, amount: array[idx].amount)
                            
                            if let idx = array.firstIndex(where: {($0.amount ?? "").isEmpty }) {
                                self.dic[VM_currencyConversion.to] = PickerSelectedValue(currency: array[idx].currency, amount: nil)
                                self.exchangeRate()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveCurrencies() {
        let currencies = self.dic.values.compactMap({$0.currency})
        UserDefaults.standard.setCurrencies(values: currencies)
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

        self.webManager?.exchangeRate(from: fromCurrency, to: toCurrency, amount: Double(amount)!)
    }
}







//MARK: - UpdateVM
extension VM_currencyConversion : UpdateVM {
    
    func updateValueForPicker(currency: String, isFirst_head: Bool) {
        self.isFirst_head = isFirst_head
        if !currency.isEmpty {
            self.uidelegate?.updateText(string: currency, isFirst_head: self.isFirst_head)
            self.grabValues()
        }
    }
    
    func updateCurrentAmout(amount: String, isFirst_head: Bool) {
        self.isFirst_head = isFirst_head
        if !amount.isEmpty { self.grabValues() }
        else {
            URLSession.shared.cancelTaskWithUrl(shouldCancelAll: true)
            self.uidelegate?.clearAllAmounts()
        }
    }
}





//MARK: - CurrencyConversionProtocol
extension VM_currencyConversion : CurrencyConversionProtocol {
    
    var currenciesCount: Int {
        return self.currencies.count
    }
    
    func getCurrency(index: Int) -> String {
        return self.currencies[index]
    }
    
    func valueSwaped() {
        self.grabValues()
    }
    
    func updateCurrencyOrAmount(currency: String, isFirst_head: Bool, isCurrency: Bool) {
        
        if isCurrency {
            self.updateValueForPicker(currency: currency, isFirst_head: isFirst_head)
        }
        else {
            self.updateCurrentAmout(amount: currency, isFirst_head: isFirst_head)
        }
    }
    
    
    func showHistory() {
        
        let baseCurrency = "USD"
        
        guard var currencies = UserDefaults.standard.getCurrencies, currencies.count > 0 else { return }
        currencies.removeAll(where: {$0 == baseCurrency})
        let currenciesString = currencies.joined(separator: ",")
        
        let startDate = Helper.calculatedDate(howManyDaysBack: 3)
        let endDate = Helper.calculatedDate(howManyDaysBack: 1)
        
        FetchHistoricalRates(delegate: self).timeseries(startDate: startDate,
                                                        endDate: endDate,
                                                        symbols: currenciesString,
                                                        baseCurrency: baseCurrency)
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




//MARK: - FetchAndCalculateCurrencyProtocol
extension VM_currencyConversion : FetchAndCalculateCurrencyProtocol {
    
    func symbolsFetched(symbols: Symobls?, error: String?) {
        
        self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
            
            if let symbols = symbols, symbols.symbols?.count ?? 0 > 0 {
                self.currencies = symbols.symbolsArray.sorted()
            }
        }
    }
    
    func exchangeRate(convertedValues: ConvertedResponse?, error: String?) {
        
        self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
            if let convertedValues = convertedValues {

                self.saveCurrencies()
                self.uidelegate?.currencyResult(amount: convertedValues.description, isFirst_head: self.isFirst_head)
            }
        }
    }
}



//MARK: - FetchHistoricalRatesProtocol
extension VM_currencyConversion : FetchHistoricalRatesProtocol {
    func historicalRatesFetched(history: HistoricalRatesProtocol?, error: String?) {
        
        self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
            guard let history = history, history.rates?.count ?? 0 > 0 else {
                self.errorDelegate?.showError(message: Constants.GeneralConstants.noHistoryRecordFound)
                return
            }
            self.uidelegate?.historicalRates(rates: history)
        }
    }
}

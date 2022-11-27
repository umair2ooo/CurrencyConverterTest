import Foundation


class VM_popularCurrencyRates {
    
    private let errorDelegate : ShowErrorProtocol?
    
    var popularCurrencyRates : PopularCurrRatesProtocol? {
        didSet {
            self.delegate?.popularCurrRatesFetched()
        }
    }
    private let delegate : UpdateUIForPopularCurrency?
    
    private var webManager : FetchPopularCurrencies?
    
    
    init(delegate : UpdateUIForPopularCurrency?, errorDelegate : ShowErrorProtocol?) {
        self.errorDelegate = errorDelegate
        self.delegate = delegate
        
        self.webManager = FetchPopularCurrencies(delegate: self)
        self.webManager?.popularCurr()
    }
}


extension VM_popularCurrencyRates : PopuplarCurrencyProtocol {
    var popularRtsCount: Int {
        return self.popularCurrencyRates?.rateArray.count ?? 0
    }
    
    func getCurrencyAndRate(indexPath: IndexPath) -> String {

        return String(format: "%@: %.2f",
                      self.popularCurrencyRates!.rateArray[indexPath.row].currency,
                      self.popularCurrencyRates!.rateArray[indexPath.row].rate)
    }
}





//MARK: - PopuplarCurrencyProtocol
extension VM_popularCurrencyRates : PopularCurrenciesRatesProtocol {
    func popularCurrenciesRates(values: PopularCurrRatesProtocol?, error: String?) {
        
        self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
            if let values = values {

                self.popularCurrencyRates = values
            }
        }
    }
}



//MARK: - CheckErrorExistence
extension VM_popularCurrencyRates : CheckErrorExistence {
    func showErrorIfExists(delegate: ShowErrorProtocol?, error: String?, success: () -> ()) {
        
        guard let error = error else {
            success()
            return
        }
        delegate?.showError(message: error)
    }
}

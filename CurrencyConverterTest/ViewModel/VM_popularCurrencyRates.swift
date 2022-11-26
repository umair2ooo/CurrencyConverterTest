import Foundation


class VM_popularCurrencyRates {
    
    private let errorDelegate : ShowErrorProtocol?
    
    var popularCurrencyRates : PopularCurrRatesProtocol? {
        didSet {
            self.delegate.popularCurrRatesFetched()
        }
    }
    private let delegate : UpdateUIForPopularCurrency
    
    
    
    
    init(delegate : UpdateUIForPopularCurrency, errorDelegate : ShowErrorProtocol?) {
        self.errorDelegate = errorDelegate
        self.delegate = delegate
        self.fetchPopularCurr()
    }
    
    private func fetchPopularCurr() {
        
        WebServices.popularCurr { [weak self] commonCurrRates, error in
            
            guard let self = self else { return }
            
            self.showErrorIfExists(delegate: self.errorDelegate, error: error) {
                guard let commonCurrRates = commonCurrRates, commonCurrRates.rates?.count ?? 0 > 0 else {
                    self.errorDelegate?.showError(message: Constants.GeneralConstants.noHistoryRecordFound)
                    return
                }
                self.popularCurrencyRates = commonCurrRates
            }
        }
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

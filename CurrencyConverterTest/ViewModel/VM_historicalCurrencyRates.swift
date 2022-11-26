import Foundation



class VM_historicalCurrencyRates {
    var history : HistoricalRatesProtocol! {
        didSet {
            self.historicalRts = history.ratesArray
        }
    }

    private let delegate : UpdateUIForHistoricalRates
    private let errorDelegate : ShowErrorProtocol?
    private var historicalRts : [RateArrayModel]? {
        didSet {
            self.delegate.updateUIForHistoricalRates()
        }
    }

    
    init(delegate : UpdateUIForHistoricalRates, errorDelegate : ShowErrorProtocol?) {
        
        self.delegate = delegate
        self.errorDelegate = errorDelegate
    }
}


extension VM_historicalCurrencyRates : HistoricalCurrencyCalculator {
    
    func setHistory(history: HistoricalRatesProtocol) {
        self.history = history
    }
    var historicalRtsCount: Int? {
        return self.historicalRts?.count ?? 0
    }
    
    func getCurrencyAndRate(indexPath: IndexPath) -> String {
        return String(format: "%@: %.2f",
                      self.historicalRts![indexPath.section].currencies[indexPath.row].currency,
                      self.historicalRts![indexPath.section].currencies[indexPath.row].rate)
    }
    
    func currCountOnEachDate(sectionIndex: Int) -> Int {
        return self.historicalRts![sectionIndex].currencies.count
    }
    
    func getDate(section: Int) -> String {
        return self.historicalRts![section].date
    }
}



//MARK: - CheckErrorExistence
extension VM_historicalCurrencyRates : CheckErrorExistence {
    func showErrorIfExists(delegate: ShowErrorProtocol?, error: String?, success: () -> ()) {
        
        guard let error = error else {
            success()
            return
        }
        delegate?.showError(message: error)
    }
}

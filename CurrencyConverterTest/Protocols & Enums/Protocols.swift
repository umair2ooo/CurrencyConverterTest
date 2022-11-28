import Foundation



typealias HTTPCompletion = ((Result<Decodable>) -> Void)


// owned by Models
protocol ErrorVerificationInDecodable {
    var success : Bool {get}
    var error : ModelError? {get}
}


protocol NetworkLoader {
    func loadData<T>(using request: URLRequest, type: T.Type, with completion: @escaping HTTPCompletion) where T : Decodable & ErrorVerificationInDecodable
}


protocol ResponderProtocol {
    func showError(message : String)
    func fillPickerInitial(currencyFirst : Int, currencySecond : Int, firstText : String?, secondText : String?)
    func updateText(string : String, isFirst_head : Bool)
    func currencyResult(amount : String, isFirst_head: Bool)
    func getValuesOfPickerAndTF(isFirst_head: Bool) -> [(currency : String?, amount : String?)]
    func clearAllAmounts()
    func historicalRates(rates : HistoricalRatesProtocol)
}


protocol CalculateConversionProtocol {
    func calculate()
}


protocol UpdateVM {
    func updateValueForPicker(currency: String, isFirst_head: Bool)
    func updateCurrentAmout(amount : String, isFirst_head: Bool)
}



protocol History {
    func showHistory()
}


protocol UpdateUIForPopularCurrency {
    func popularCurrRatesFetched()
}

protocol UpdateUIForHistoricalRates {
    func updateUIForHistoricalRates()
}


/*
protocol HistoricalCurrencyCalculator {
    
    var historicalRtsCount : Int? {get}
    func getCurrencyAndRate(indexPath : IndexPath) -> String
    func currCountOnEachDate(sectionIndex : Int) -> Int
    func getDate(section : Int) -> String
    func setHistory(history : HistoricalRatesProtocol)
}
*/


protocol HistoricalRatesProtocol {
    
    var base : String? { get }
    var endDate: String? { get }
    var rates: [String: [String: Double]]? {get}
    var startDate: String? { get }
    var timeseries: Bool? { get }
    
    var ratesArray : [RateArrayModel] { get }
}


protocol PopularCurrRatesProtocol {
    var base : String? {get}
    var date: String? {get}
    var rates: [String: Double]? {get}
    var timestamp: Int? {get}
    var rateArray : [ParticularCurrency] { get }
}

protocol PopuplarCurrencyProtocol {
    var popularRtsCount : Int {get}
    func getCurrencyAndRate(indexPath : IndexPath) -> String
}

protocol CheckErrorExistence {
    
    func showErrorIfExists(delegate : ShowErrorProtocol?, error: String?, success : ()->())
}


protocol ShowErrorProtocol {
    func showError(message: String)
}



protocol CurrencyConversionProtocol {
    var currenciesCount : Int { get }
    func getCurrency(index : Int) -> String
    func valueSwaped()
    func updateCurrencyOrAmount(currency: String, isFirst_head: Bool, isCurrency : Bool)
    func showHistory()
}

extension CurrencyConversionProtocol {
    func showHistory() {}
}



protocol ShowHistoryProtocol {
    func showHistory()
}

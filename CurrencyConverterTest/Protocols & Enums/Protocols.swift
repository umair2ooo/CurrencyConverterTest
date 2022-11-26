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
    func fillPickerInitial(currencyFirst : Int, currencySecond : Int, firstText : String?, secondText : String?, isSwape : Bool)
    func updateText(string : String, isFirst_head : Bool)
    func currencyResult(amount : String, isFirst_head: Bool)
    func getValuesOfPickerAndTF(isFirst_head: Bool) -> [(currency : String?, amount : String?)]
    func clearAllAmounts()
    func historicalRates(rates : HistoricalRates)
}


protocol CalculateConversionProtocol {
    func valuesSwapped()
    func calculate()
}


protocol UpdateVM {
    func updateValueForPicker(currency: String, isFirst_head: Bool)
    func updateCurrentAmout(amount : String, isFirst_head: Bool)
}

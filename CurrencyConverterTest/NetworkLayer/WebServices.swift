import Foundation

protocol FetchAndCalculateCurrencyProtocol {

    func symbolsFetched(symbols : SymoblsModelProtocol?, error : String?)
    func exchangeRate(convertedValues : CurrencyConvertedModel?, error : String?)
}

class FetchAndCalculateCurrency {
    
    var delegate : FetchAndCalculateCurrencyProtocol?
    
    init(delegate : FetchAndCalculateCurrencyProtocol?) {
        self.delegate = delegate
    }
    
    
    func symbols() {
        
        let router = Router.symbols.getURL
        HTTP.execute(request: router, type: Symobls.self) { model, error in
            self.delegate?.symbolsFetched(symbols: model as? SymoblsModelProtocol, error: error)
        }
    }
    
    
    func exchangeRate(from : String, to : String, amount : Double) {
        
        let router = Router.convert(from: from, to: to, amount: amount).getURL
        HTTP.execute(request: router, type: CurrencyConvertedModel.self) { model, error in
            self.delegate?.exchangeRate(convertedValues: model as? CurrencyConvertedModel, error: error)
        }
    }
}











protocol FetchHistoricalRatesProtocol {
    func historicalRatesFetched(history : HistoricalRatesProtocol?, error : String?)
}


class FetchHistoricalRates {
    
    var delegate : FetchHistoricalRatesProtocol?
    
    init(delegate : FetchHistoricalRatesProtocol?) {
        self.delegate = delegate
    }
    
    
    func timeseries(startDate : String,
                           endDate : String,
                           symbols: String,
                           baseCurrency: String) {

        let router = Router.timeseries(startDate: startDate, endDate: endDate, symbols: symbols, baseCurrency: baseCurrency).getURL
        HTTP.execute(request: router, type: HistoricalRates.self) { model, error in
            self.delegate?.historicalRatesFetched(history: model as? HistoricalRatesProtocol, error: error)
        }
    }
}














protocol PopularCurrenciesRatesProtocol {
    func popularCurrenciesRates(values : PopularCurrRatesProtocol?, error: String?)
}


class FetchPopularCurrencies {
    
    var delegate : PopularCurrenciesRatesProtocol?
    
    init(delegate : PopularCurrenciesRatesProtocol?) {
        self.delegate = delegate
    }
    
    func popularCurr() {

        let router = Router.latest.getURL
        HTTP.execute(request: router, type: PopularCurrencyRates.self) { model, error in
            self.delegate?.popularCurrenciesRates(values: model as? PopularCurrRatesProtocol, error: error)
        }
    }
}

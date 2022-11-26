import Foundation

class WebServices {
    

    static func symbols(completion : @escaping (Symobls?, String?)->()) {
        
        let router = Router.symbols.getURL
        HTTP.execute(request: router, type: Symobls.self) { model, error in
            completion(model as? Symobls, error)
        }
    }
    
    
    static func exchangeRate(from : String, to : String, amount : Double, completion : @escaping (ConvertedResponse?, String?)->()) {
        
        let router = Router.convert(from: from, to: to, amount: amount).getURL
        HTTP.execute(request: router, type: ConvertedResponse.self) { model, error in
            completion(model as? ConvertedResponse, error)
        }
    }
    
    
    static func timeseries(startDate : String,
                           endDate : String,
                           symbols: String,
                           baseCurrency: String,
                           completion : @escaping (HistoricalRatesProtocol?, String?)->()) {

        let router = Router.timeseries(startDate: startDate, endDate: endDate, symbols: symbols, baseCurrency: baseCurrency).getURL
        HTTP.execute(request: router, type: HistoricalRates.self) { model, error in
            completion(model as? HistoricalRatesProtocol, error)
        }
    }
    
    
    static func popularCurr(completion : @escaping (PopularCurrRatesProtocol?, String?)->()) {

        let router = Router.latest.getURL
        HTTP.execute(request: router, type: PopularCurrencyRates.self) { model, error in
            completion(model as? PopularCurrRatesProtocol, error)
        }
    }
}

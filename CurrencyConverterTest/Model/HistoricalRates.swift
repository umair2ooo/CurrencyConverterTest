import Foundation


class HistoricalRates: ModelBase {
    var base, endDate: String?
    var rates: [String: [String: Double]]?
    var startDate: String?
    var timeseries: Bool?
    
    var ratesArray : [RateArrayClass] {
        rates!.compactMap{RateArrayClass(date:$0.key, currencies: $0.value.compactMap{ ParticularCurrency(currency:$0.key, rate: $0.value)}.sorted{$0.currency<$1.currency})}.sorted{$0.date>$1.date}
    }
    

    enum CodingKeys: String, CodingKey {
        case base
        case endDate = "end_date"
        case rates
        case startDate = "start_date"
        case success, timeseries
    }

    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {self.base = try container.decode(String.self, forKey: .base)}
        catch {self.base = nil}
        
        do {self.endDate = try container.decode(String.self, forKey: .endDate)}
        catch {self.endDate = nil}
        
        do {self.startDate = try container.decode(String.self, forKey: .startDate)}
        catch {self.startDate = nil}
        
        do {self.rates = try container.decode([String: [String: Double]].self, forKey: .rates)}
        catch {self.rates = nil}
        
        do {self.timeseries = try container.decode(Bool.self, forKey: .timeseries)}
        catch {self.timeseries = nil}
    }
}


extension HistoricalRates : ErrorVerificationInDecodable {}



struct RateArrayClass {
    let date : String
    let currencies : [ParticularCurrency]
}

struct ParticularCurrency {
    let currency : String
    let rate : Double
}

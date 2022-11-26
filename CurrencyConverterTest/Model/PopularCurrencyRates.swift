import Foundation


class PopularCurrencyRates: ModelBase {
    var base, date: String?
    var rates: [String: Double]?
    var timestamp: Int?

    
    private enum CodingKeys: String, CodingKey {
        case base, date, rates, timestamp
    }
    
    // In-case if value fails to set, we've implemented catch
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {self.base = try container.decode(String.self, forKey: .base)}
        catch {self.base = nil}
        
        do {self.date = try container.decode(String.self, forKey: .date)}
        catch {self.date = nil}
        
        do {self.rates = try container.decode([String : Double].self, forKey: .rates)}
        catch {self.rates = nil}
        
        do {self.timestamp = try container.decode(Int.self, forKey: .timestamp)}
        catch {self.timestamp = nil}
    }
}

extension PopularCurrencyRates : PopularCurrRatesProtocol {
    var rateArray: [ParticularCurrency] {
        return self.rates?.compactMap { ParticularCurrency(currency:$0.key, rate:$0.value)} ?? []
    }
}

extension PopularCurrencyRates : ErrorVerificationInDecodable {}

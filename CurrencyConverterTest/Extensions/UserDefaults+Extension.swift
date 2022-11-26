import Foundation


extension UserDefaults {
    
    func setCurrencies(values: [String]) {
        
        var array = values
        
        if var oldCurrencies = getCurrencies, (oldCurrencies.count > 0) {
            oldCurrencies.append(contentsOf: array)
            array = Array(Set(oldCurrencies))
        }
        
        set(array, forKey: Constants.GeneralConstants.currenciesToLocal)
    }
    var getCurrencies : [String]? {
        return value(forKey: Constants.GeneralConstants.currenciesToLocal) as? [String]
    }
}

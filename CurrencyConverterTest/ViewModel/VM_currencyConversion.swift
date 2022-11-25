import Foundation


class CurrencyConversion {
    
    init() {
        fetchSymbols()
    }
    
    
    private func fetchSymbols() {
        
        return
        
        
        WebServices.symbols { [weak self] array, error in
            
            guard let self = self else { return }
            self.showErrorIfExists(error: error) {
                print("array.symbolsArray : \(array!.symbolsArray)")
            }
        }
    }
    
    
    private func showErrorIfExists(error: String?, success : ()->()) {
        
        guard let error = error else {
            success()
            return
        }
    }
}

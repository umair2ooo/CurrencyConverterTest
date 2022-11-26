import Foundation

extension Date {
    
    func formattedDateForCurrency() -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        let dateInString = dateFormatterPrint.string(from: self)
        print(dateInString)
        
        return dateInString
    }
}

import Foundation


class Helper {
    
    static func calculatedDate(howManyDaysBack : Int) -> String {

        let previousThreeDays = Calendar.current.date(byAdding: .day, value: -howManyDaysBack, to: Date())!
        return previousThreeDays.formattedDateForCurrency()
    }
}

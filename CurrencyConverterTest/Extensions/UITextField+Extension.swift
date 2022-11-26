import Foundation
import UIKit


extension UITextField {
    
    var getPicker : UIPickerView? {
        if let picker = self.inputView as? UIPickerView {
            return picker
        }
        return nil
    }
}

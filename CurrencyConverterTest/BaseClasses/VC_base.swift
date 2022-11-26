import UIKit

class VC_base: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension VC_base : ShowErrorProtocol {
    
    
    func showError(message: String) {
        self.showAlert(title: "Error", message: message)
    }
}

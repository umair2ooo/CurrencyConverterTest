import UIKit

class VC_master: VC_base {

    var history : HistoricalRatesProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.GeneralConstants.history
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier : \(segue.identifier)")
        print("segue.destination : \(segue.destination)")
        
        if let vc = segue.destination as? VC_history {
            vc.history = self.history
        }
    }
}

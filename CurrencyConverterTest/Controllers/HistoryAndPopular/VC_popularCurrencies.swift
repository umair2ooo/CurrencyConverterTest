import UIKit

class VC_popularCurrencies: VC_base {
    
    
    @IBOutlet weak var tv_popularCurrRates: UITableView!
    
    
    private var vm_popularCurrency : PopuplarCurrencyProtocol!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm_popularCurrency = VM_popularCurrencyRates(delegate: self, errorDelegate: self)
        self.setupUI()
    }
    
    
    private func setupUI() {

        self.tv_popularCurrRates.sectionHeaderTopPadding = 0.0
    }
}


//MARK: - UITableViewDataSource
extension VC_popularCurrencies : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm_popularCurrency.popularRtsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        cell!.textLabel?.text = self.vm_popularCurrency.getCurrencyAndRate(indexPath: indexPath)
        
        return cell!
    }
}



//MARK: - UpdateUIForPopularCurrency
extension VC_popularCurrencies : UpdateUIForPopularCurrency {
    func popularCurrRatesFetched () {
        self.tv_popularCurrRates.reloadData()
    }
}

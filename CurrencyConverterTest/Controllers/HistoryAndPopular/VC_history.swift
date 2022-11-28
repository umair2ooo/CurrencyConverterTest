import UIKit

class VC_history: VC_base {
    
    
    
    @IBOutlet weak var lbl_baseCurr: UILabel!
    @IBOutlet weak var tv_history: UITableView!
    
    
    
    var history : HistoricalRatesProtocol! {
        didSet {
            self.historicalRts = history.ratesArray
        }
    }

    private var historicalRts : [RateArrayModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    private func setupUI() {
        self.tv_history.sectionHeaderTopPadding = 0.0
        
        if let base = self.history.base {
            self.lbl_baseCurr.text = "\(Constants.GeneralConstants.from) \(base) \(Constants.GeneralConstants.to):"
        }
    }
}


//MARK: - UITableViewDataSource
extension VC_history : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.historicalRts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historicalRts![section].currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        cell!.textLabel?.text = String(format: "%@: %.2f",
                                       self.historicalRts![indexPath.section].currencies[indexPath.row].currency,
                                       self.historicalRts![indexPath.section].currencies[indexPath.row].rate)
        
        return cell!
    }
}


//MARK: - UITableViewDelegate
extension VC_history : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard tableView == self.tv_history else { return nil }
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .gray
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = self.historicalRts![section].date
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        
        headerView.addSubview(label)
        
        return headerView
    }
}



//MARK: - UpdateUIForHistoricalRates
extension VC_history : UpdateUIForHistoricalRates{
    func updateUIForHistoricalRates() {
        self.tv_history.reloadData()
    }
}

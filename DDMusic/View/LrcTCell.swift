

import UIKit

class LrcTCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: LrcLable!
    
    var lrcConent : String = "" {
        didSet {
            lrcLabel.text = lrcConent
        }
    }
    
    var progress : CGFloat = 0 {
        didSet {
            lrcLabel.radion = progress
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cellWithTableView(tableView : UITableView) -> LrcTCell {
        let cellId = "LrcTCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)

        if cell == nil {
            cell = Bundle.main.loadNibNamed("LrcTCell", owner: nil, options: nil)?.first as! LrcTCell?
        }
        return cell as! LrcTCell
    }
}

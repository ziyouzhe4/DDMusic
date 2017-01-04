

import UIKit

class MusicListCell: UITableViewCell {
    
    var musicM : MusicModel? {
        didSet {
            singerIconImageView.image = UIImage(named: (musicM?.singerIcon)!)
            songNameLabel.text = musicM?.name
            
            singerNameLabel.text = musicM?.singer
        }
    }
    @IBOutlet weak var singerIconImageView: UIImageView!

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    class func cellWithTableView(tableView : UITableView) ->MusicListCell {
        let cellID = "MusicListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MusicListCell
        if cell == nil {
            //print("貌似有问题")
            cell = Bundle.main.loadNibNamed("MusicListCell", owner: nil, options: nil)?.first as?MusicListCell
        }
        return cell!
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib( )
        //layout不能获取真正的控价大小 所以需要调用此方法进行绘制
        self.layoutIfNeeded()
         
        singerIconImageView.layer.cornerRadius = singerIconImageView.width * 0.5
        singerIconImageView.layer.masksToBounds = true
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}


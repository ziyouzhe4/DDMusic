

import UIKit
import MediaPlayer

class MusicListVC: UITableViewController {

    fileprivate var musicMs : [MusicModel] = [MusicModel](){
        
        didSet{
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        MusicDataTool.getMusicMs { (models : [MusicModel]) in
            print(models)
            
            self.musicMs = models
            /* 获取数据赋值 */
            MusicOperationTool.shareInstance.musicsM = models
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

 
 
}

extension MusicListVC{
    
    fileprivate func setupUI(){
        
        self.title = "JJMusic"
        tableView.rowHeight = 60.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
   
    
}

// MARK:- 代理数据源
extension MusicListVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicListCell.cellWithTableView(tableView: tableView)
        //cell 赋值
        cell.musicM = self.musicMs[indexPath.row]

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let musics = musicMs[indexPath.row]
        print("播放音乐", musics.name ?? "")
        MusicOperationTool.shareInstance.playMusic(musics: musics)
        self.performSegue(withIdentifier: "listToDetail", sender: nil)
        
    }
    
}



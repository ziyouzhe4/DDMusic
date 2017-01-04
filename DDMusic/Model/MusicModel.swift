

import UIKit

class MusicModel: NSObject {

    /*歌手的图片 */
    var singerIcon : String?
    
    /* 歌词名字 */
    var lrcName : String?

    /* 歌曲路径 */
    var fileName : String?
    
    /*  歌曲名字*/
    var name : String?
    
    /* 歌手名字  */
    var singer : String?
    
    override init() {
        super.init()
    }
    
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
}

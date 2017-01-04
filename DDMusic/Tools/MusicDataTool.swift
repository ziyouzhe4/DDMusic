

import UIKit

class MusicDataTool: NSObject {

    //使用闭包 以后可以从网络获取 直接返回的话 异步是不可以的
    class func getMusicMs(result : ([MusicModel]) ->()) {
        //1 获取文件路径
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([MusicModel]())
            return
        }
        
        //获取文件内容
        guard let array = NSArray(contentsOfFile: path) else {
            result([MusicModel]())
            return
        }
        
        //文件解析
        var models = [MusicModel]()
        for dic in array {
            
            let model = MusicModel(dic: dic as! [String : AnyObject])
            models.append(model)
        }
        result(models)
    }
    /* 获得所有歌词模型 */
    class func getLrcMS(lrcName : String?) -> ([LrcModel]) {
        if lrcName == nil {
            return [LrcModel]()
        }
        // 1 读取文件的路径
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else { return  [LrcModel]()}
        
        // 2 读取文件中的内容呢
         var lrcConent = ""
        do {
             lrcConent = try String(contentsOfFile: path)
        } catch {
            print(error)
            return [LrcModel]()
        }
        // 3 解析字符串
        //print(lrcConent)
        
        var resultArray = [LrcModel]()
        let conentArray = lrcConent.components(separatedBy: "\n")
        for  var conentString in conentArray {
            if conentString.contains("[ti:") || conentString.contains("[ar:") || conentString.contains("[t_time:"){
                continue
            }
            //删除第一个括号
             conentString = conentString.replacingOccurrences(of: "[", with: "")
            let detailArray = conentString.components(separatedBy: "]")
            if detailArray.count != 2 {
                continue
            }
            let startTime = TimeTool.getFormatTimeToTimeInval(format: detailArray[0])
            var content = detailArray[1]
            
            content = content.replacingOccurrences(of: "\r", with: "")
            let model = LrcModel()
            resultArray.append(model)
            model.beginTime = startTime
            model.conent = content
        }
        
        //遍历resultArray 第二个参数的开始时间是第一个的结束时间
        let count = resultArray.count
        for rs in 0..<count {
            
            if rs == count - 1 {
                break
            }
            let lrcM = resultArray[rs]
            let nextLrcM = resultArray[rs + 1]
            lrcM.endTime = nextLrcM.beginTime
        }
        
        return resultArray
    }
    /* 获取当前播放的歌词模型 */
    class func getCurrntLrcModel (currentTime : TimeInterval, lrcModel : [LrcModel]) -> ( row : Int , model : LrcModel?) {
        
        var index = 0
        for lrcM in lrcModel {
            
            if lrcM.endTime >= currentTime && lrcM.beginTime <= currentTime {
                
                return (index, lrcM)
            }
            index += 1
        }
        return (0,nil)
    }
}

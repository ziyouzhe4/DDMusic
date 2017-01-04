

import UIKit
import MediaPlayer
/* 音乐操作队列工具 */

class MusicOperationTool: NSObject {

    //单例 数据共享
    static let shareInstance = MusicOperationTool()
    //工具类
    let tool : MusicTool = MusicTool()
    
    var artWork : MPMediaItemArtwork?
    /* 上次歌词行号，防止多次加载绘制歌词到图片上 */
    var lastLrcRow = -1
    var musicModel : MusicMessageModel = MusicMessageModel()
    
    func getMusicMessage() ->MusicMessageModel {
        musicModel.modelM = musicsM[currentPlayMusicIndex]
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        musicModel.totalTime = (tool.player?.duration) ?? 0
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        return musicModel
    }
    /* 列表数组 */
    var musicsM : [MusicModel] = [MusicModel]()
    
    var currentPlayMusicIndex = -1 {
        didSet {
            
            if currentPlayMusicIndex < 0 {
                currentPlayMusicIndex = musicsM.count - 1
            }
            if currentPlayMusicIndex > musicsM.count - 1 {
                currentPlayMusicIndex = 0
            }
        }
    }
    
    /* 播放音乐 */
    func playMusic(musics : MusicModel) {
        tool.playMusicWithName(musicName: musics.fileName!)
        currentPlayMusicIndex = musicsM.index(of: musics)!
        
        print("当前的播放的是第几首歌曲", (currentPlayMusicIndex))
        
    }
    /* 详情界面调用 播放当前音乐 */
    func playCurrnetMusic () {
        let model = musicsM[currentPlayMusicIndex]
        playMusic(musics: model)
    }
    /* 暂停音乐 */
    func pauseCurrnentMusic() {
        tool.pauseMusic()
    }
    /* 下一首音乐 */
    func nextMusic() {
        /* 下一个数据 */
        currentPlayMusicIndex += 1
        
        //取出数据
        let model = musicsM[currentPlayMusicIndex]
        playMusic(musics: model)
    }
    /* 上一首音乐 */
    func preMusic() {
        /* 上一个数据 */
        currentPlayMusicIndex -= 1
        
        //取出数据
        let model = musicsM[currentPlayMusicIndex]
        playMusic(musics: model)
    }
    /* 设置播放比例是多少 */
    func setPlayerPlayRotate(progress : CGFloat) {
        if tool.getCurrnetPlayerPlayRotate() == progress {
            return
        }
        let duration = tool.player?.duration
        tool.player?.currentTime = TimeInterval(progress) * duration!
    }
}
/* 锁屏解密通信 */
extension MusicOperationTool {
    func setUpLocakMessage() -> () {
        /* 可以不将歌词添加到图片 */
        let socket = true
        let message = getMusicMessage()
        let mediaCenter = MPNowPlayingInfoCenter.default()
        
        //标题
        let title = message.modelM?.name ?? ""
        let singerName = message.modelM?.singer ?? ""
        
        let costTime = message.costTime
        let totalTime = message.totalTime
        let iconName = message.modelM?.singerIcon ?? ""
        
        //获取歌词
        let lrcName = message.modelM?.lrcName
        let lrcMs = MusicDataTool.getLrcMS(lrcName: lrcName)
        let lrcM = MusicDataTool.getCurrntLrcModel(currentTime: message.costTime, lrcModel: lrcMs).model
        let lrcRow = MusicDataTool.getCurrntLrcModel(currentTime: message.costTime, lrcModel: lrcMs).row
        var image = UIImage(named: iconName)
        
        var dic : [String : Any] = [
            MPMediaItemPropertyTitle : title,
            MPMediaItemPropertyArtist : singerName,
            MPMediaItemPropertyPlaybackDuration : totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime : costTime,
            ]
        if socket && lrcRow != lastLrcRow && image != nil {
            lastLrcRow = lrcRow
            image = LrcAddImageTool.addLrcToImage(lrc: lrcM?.conent, sourceImage: image)
            if image != nil {
                artWork = MPMediaItemArtwork(image: image!)
            }
            
        }
        if artWork != nil {
            dic[MPMediaItemPropertyArtwork] = artWork
        }
        mediaCenter.nowPlayingInfo = dic
        
        //开始接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
}



import UIKit

class LrcLable: UILabel {

    var radion : CGFloat = 0 {
        didSet {
           // if radion == oldValue {
             //   return
            //}
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        UIColor.red.set()
        let rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radion, height: rect.size.height)
        UIRectFillUsingBlendMode(rect, .sourceIn)
    }
 

}

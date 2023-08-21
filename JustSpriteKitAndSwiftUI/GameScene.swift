import Foundation
import SpriteKit

class GameScene: SKScene
{
    private var lastUpdateTime: TimeInterval = 0
    private var boundaries: CGRect!
    
    override
    func didChangeSize(_ oldSize: CGSize)
    {
        boundaries = CGRect(x: -self.frame.width / 2, y: -self.frame.height / 2, width: self.frame.width,
                            height: self.frame.height)
    }
    
    override
    func update(_ currentTime: TimeInterval)
    {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - self.lastUpdateTime
        
        for node in children
        {
            if node is SKCameraNode
            {
                continue
            }
            
            let angle = node.userData![0] as! Double
            var position = SIMD2<Double>(node.position.x, node.position.y) + SIMD2<Double>(cos(angle), sin(angle)) * 50 * deltaTime
            
            if position.x > boundaries.maxX
            {
                position.x = boundaries.maxX
                node.userData![0] = Double.pi - angle
            }
            else if position.x < boundaries.minX
            {
                position.x = boundaries.minX
                node.userData![0] = Double.pi - angle
            }
            else if position.y < boundaries.minY
            {
                position.y = boundaries.minY
                node.userData![0] = -angle
            }
            else if position.y > boundaries.maxY
            {
                position.y = boundaries.maxY
                node.userData![0] = -angle
            }
            
            node.position.x = position.x
            node.position.y = position.y
        }
        
        self.lastUpdateTime = currentTime
    }
}

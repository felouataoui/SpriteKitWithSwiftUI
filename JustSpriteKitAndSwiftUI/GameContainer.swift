import SwiftUI
import SpriteKit

struct GameContainer: View
{
    var body: some View
    {
        ZStack
        {
            SpriteView(
                scene: loadScene(),
                options: .ignoresSiblingOrder,
                debugOptions: [.showsFPS, .showsDrawCount])
            .ignoresSafeArea()
            
            GameUI()
        }
        .statusBarHidden(true)
    }
    
    private func loadScene()
    -> SKScene
    {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        
        // Create a camera
        // This not necessary but why not?
        let camera = SKCameraNode()
        scene.addChild(camera)
        scene.camera = camera
        
        // Generate a grayscale noise shared texture
        let texture = SKTexture(noiseWithSmoothness: 0, size: CGSize(width: 8, height: 8), grayscale: true)
        
        // Create the rectangles
        for _ in 1...20000
        {
            let rectangle = SKSpriteNode(texture: texture, color: .white, size: CGSize(width: 8, height: 8))
            rectangle.userData = [0: Double.random(in: -Double.pi...Double.pi)]
            scene.addChild(rectangle)
        }
        
        return scene
    }
}

struct GameContainer_Previews: PreviewProvider
{
    static var previews: some View
    {
        GameContainer()
    }
}

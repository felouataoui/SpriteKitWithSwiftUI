import SwiftUI
import RealityKit

struct GameContainer: View
{
    var body: some View
    {
        ZStack
        {
            // Can't use RealityView in iOS
            ARViewAdapter()
                .ignoresSafeArea()
            GameUI()
        }
        .statusBarHidden(true)
    }
}

struct ARViewAdapter: UIViewRepresentable
{
    func makeUIView(context: Context)
    -> ARView
    {
        let view = ARView(frame: UIScreen.main.bounds)
        view.cameraMode = .nonAR
        view.debugOptions = [.showStatistics]
        
        // Register the components and systems
        MovementComponent.registerComponent()
        BoundaryComponent.registerComponent()
        MovementSystem.registerSystem()
        
        // Configure a perspective camera so that distances from meters to pixels are identical
        // This allows us to manipulate entity positions in meters as if they were in pixels
        let scene2DAnchor = RealityKit.AnchorEntity(world: .zero)
        view.scene.addAnchor(scene2DAnchor)
        
        let cameraAnchor = AnchorEntity(world: .zero)
        view.scene.addAnchor(cameraAnchor)
        
        let cameraEntity = PerspectiveCamera()
        let fieldOfViewInRadians = cameraEntity.camera.fieldOfViewInDegrees * (Float.pi / 180)
        let distance = Float(view.frame.height) / (2 * tanf(fieldOfViewInRadians / 2))
        cameraEntity.position = [0, 0, distance]
        cameraAnchor.addChild(cameraEntity)
        
        /**
         Generate a rectangle template and clone it.
         Apple says this should allow instanced rendering, but in my experience it does not. Instead it will create a new mesh for every rectangle which makes
         loading slower, updating slower and raises the memory footprint.
         The only way to do it AFAIK is to use a MeshDescriptor to create a mesh with our instances, assign the mesh to an entity and update the mesh content
         every frame. Which is fine but it doesn't translate well to using an ECS.
         References:
            - https://yono.ai/articles/wwdc22-arkit-realitykit-usdz-digital-lounge/question078/
            - https://openradar.appspot.com/FB8912817
            - https://developer.apple.com/forums/thread/694561
        **/
        let mesh = MeshResource.generatePlane(width: 8, height: 8)
        
        let firstRectangle = RealityKit.Entity()
        firstRectangle.components.set(ModelComponent(mesh: mesh, materials: []))
        firstRectangle.components.set(MovementComponent(angle: Float.random(in: -Float.pi...Float.pi)))
        scene2DAnchor.addChild(firstRectangle)
        
        for _ in 2...20000
        {
            let rectangle = firstRectangle.clone(recursive: false)
            rectangle.components.set(MovementComponent(angle: Float.random(in: -Float.pi...Float.pi)))
            scene2DAnchor.addChild(rectangle)
        }
        
        // The boundary that is used to bounce the rectangles
        let boundaries = RealityKit.Entity()
        boundaries.name = "boundaries"
        boundaries.components.set(BoundaryComponent(rect: SIMD4(-Float(view.frame.width) / 2,
                                                                 -Float(view.frame.height / 2),
                                                                 Float(view.frame.width) / 2,
                                                                 Float(view.frame.height / 2))))
        scene2DAnchor.addChild(boundaries)
        
        return view
    }
    
    func updateUIView(_ view: ARView, context: Context)
    {
    }
}

struct GameContainer_Previews: PreviewProvider
{
    static var previews: some View
    {
        GameContainer()
    }
}

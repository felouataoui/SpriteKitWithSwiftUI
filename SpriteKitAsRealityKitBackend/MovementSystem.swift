import RealityKit

struct MovementSystem: RealityKit.System
{
    static let query = EntityQuery(where: .has(MovementComponent.self))
    private var boundaries: SIMD4<Float>!
            
    init(scene: RealityKit.Scene)
    {
        boundaries = scene.findEntity(named: "boundaries")!.components[BoundaryComponent.self]!.rect
    }
    
    func update(context: SceneUpdateContext)
    {
        context.scene.performQuery(Self.query).forEach
        { entity in
            let movement: MovementComponent! = entity.components[MovementComponent.self]
            entity.position = entity.position + SIMD3(cos(movement.angle), sin(movement.angle), 0) * Float(50 * context.deltaTime)
            
            if entity.position.x > boundaries.z
            {
                entity.position.x = boundaries.z
                entity.components.set(MovementComponent(angle: Float.pi - movement.angle))
            }
            else if entity.position.x < boundaries.x
            {
                entity.position.x = boundaries.x
                entity.components.set(MovementComponent(angle: Float.pi - movement.angle))
            }
            else if entity.position.y < boundaries.y
            {
                entity.position.y = boundaries.y
                entity.components.set(MovementComponent(angle: -movement.angle))
            }
            else if entity.position.y > boundaries.w
            {
                entity.position.y = boundaries.w
                entity.components.set(MovementComponent(angle: -movement.angle))
            }
        }
    }
}

struct MovementComponent: Component
{
    var angle: Float
}

struct BoundaryComponent: Component
{
    var rect: SIMD4<Float>
}

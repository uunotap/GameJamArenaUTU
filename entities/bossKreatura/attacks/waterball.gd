class_name WaterBall
extends RigidBody3D

@export var lifetime:float = 8.0
@export var damage:int = 1

var curving:bool =false

var curve_strength:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	if curving:
		# 1. Get the current direction the ball is moving
		var forward_dir = linear_velocity.normalized()

		# 2. Determine the "up" vector to find the "side" vector
		var side_direction = forward_dir.cross(global_transform.basis.y)

		# 3. Apply Centripetal Force
		var force = side_direction * curve_strength * linear_velocity.length()*delta

		apply_central_force(force)

	if linear_velocity.length() > 0.1:
		look_at(global_position + linear_velocity)



func hit(node:PhysicsBody3D):
	if node.name=="Player":
		var player:Player = node
		player.hp-=damage
	self.queue_free()


func _on_body_entered(body: Node3D) -> void:
	hit(body)

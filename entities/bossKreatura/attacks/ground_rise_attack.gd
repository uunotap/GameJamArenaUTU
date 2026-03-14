extends RigidBody3D

var lifetime: float = 2.0
var traveltime: float =1.0
var offset:float=10

var start_position: Vector3
var target_position: Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position=global_position
	target_position=start_position+(Vector3(0,offset,0))
	await get_tree().create_timer(lifetime).timeout 
	self.queue_free()

func _process(delta: float) -> void:
	self.apply_force(-global_position.move_toward(target_position, delta)*Vector3.UP)
	
	



func hit(node:PhysicsBody3D):
	if node.name=="Player":
		var player:Player = node
		player.hp-=1
	self.queue_free()


func _on_body_entered(body: Node3D) -> void:
	hit(body)

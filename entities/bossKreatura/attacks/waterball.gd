extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit(node:PhysicsBody3D):
	if node.name=="Player":
		var player:Player = node
		player.hp-=1
	self.queue_free()


func _on_body_entered(body: Node3D) -> void:
	hit(body)

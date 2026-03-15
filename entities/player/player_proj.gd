extends RigidBody3D

@export var lifetime:float = 20.0
@export var damage:int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func hit(node):

	if node.name=="Boss":
		var boss:Boss = node
		boss.hp-=damage
	self.queue_free()


func _on_body_entered(body: Node3D) -> void:
	hit(body)
	print(body)

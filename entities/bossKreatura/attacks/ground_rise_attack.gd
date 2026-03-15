extends Area3D


@export var lifetime:float = 4.0
@export var traveltime: float =1.0
@export var offset:float=10
@export var damage:int = 1

var start_position: Vector3
var target_position: Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position=global_position
	
	target_position=start_position
	target_position.y+=offset
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _process(delta: float) -> void:
	global_position = global_position.move_toward(start_position.lerp(target_position,10), delta)
	
	



func hit(node:PhysicsBody3D):
	if node.name=="Player":
		var player:Player = node
		player.hp-=damage
	self.monitoring=false

func _on_body_entered(body: Node3D) -> void:
	hit(body)

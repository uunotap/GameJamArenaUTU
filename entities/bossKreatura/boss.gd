extends Node3D


const waterball =preload("res://entities/bossKreatura/attacks/waterball.tscn")
@export var player:Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"basic attack".start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_basic_attack_timeout() -> void:
	var instance:RigidBody3D = waterball.instantiate()
	add_child(instance)
	instance.apply_impulse(global_position.direction_to(player.global_position)*10)
	

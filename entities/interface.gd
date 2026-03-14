extends Control

var hp:int = 5
func _on_player_health_changed(old:int,new:int):
	pass
	print(old)
	print(new)
	#print("Hp change old: %d, new:%d" % old % new)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

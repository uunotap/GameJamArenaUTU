extends Control

var hp:int = 5
func _on_player_health_changed(old:int,new:int):
	var hp:Array[TextureRect] =[$hp1, $hp2, $hp3, $hp4, $hp5, $hp6]
	
	var max=6
	var i=0
	for pic:TextureRect in hp:
		if i<new:
			pic.texture= load("res://assets/Life_full.png")
		else:
			pic.texture = load("res://assets/Life_empty.png")
		i+=1
	
	#I WISH THERE WAS TIME TO DO SOME COOL ANIMATION OR SOMETHING
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

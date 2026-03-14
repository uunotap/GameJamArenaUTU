extends CharacterBody3D
const waterball = preload("res://entities/bossKreatura/attacks/waterball.tscn")
const rising_attack = preload("res://entities/bossKreatura/attacks/ground rise attack.tscn")
@export var player:Player


enum attState {BASIC, ALT, SWEEP}
var stateAtt:attState = attState.BASIC
var increment:int = 0 



var hp:int = 20: set = set_hp
func set_hp(new_hp:int)-> void:
	hp=new_hp
	if hp <=4:
		invulnerability=true
		stateBoss=phaseState.PHASE3
	elif hp <=12:
		invulnerability=true
		stateBoss=phaseState.PHASE2

var invulnerability = false #??

enum phaseState {PHASE1,PHASE2, PHASE3}
var stateBoss:phaseState = phaseState.PHASE1: set = set_state
func set_state(new_state: phaseState) -> void:
	invulnerability=false
	stateBoss=new_state
	increment=0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"basic attack".start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot_ball(target:Vector3):
		var instance:RigidBody3D = waterball.instantiate()
		add_child(instance)
		instance.apply_impulse(global_position.direction_to(target)*10)

func rise_att(target:Vector3):
		var instance:Area3D = rising_attack.instantiate()
		add_child(instance)
		instance.global_position = target + Vector3(0,-2, 0)



var amount_att:int=0
var attacks:int=0
var step = 0

func phase1logic():
	if attacks >= amount_att:
		attacks=0
		print("attack step", step)
		if step == 1 :
			stateAtt=attState.ALT
			amount_att=5
		elif step == 2 or step ==0:
			stateAtt=attState.BASIC
			amount_att=50
		elif step == 3:
			stateAtt = attState.SWEEP
			amount_att=1
		else:
			step=0
		step+=1	


	if increment%2 ==0:
		attacks += 1

		if stateAtt==attState.BASIC:
			if increment%3 ==0:
				var rand_off=Vector3(randi_range(-8,8),randi_range(-2,2),randi_range(-8,8))
				shoot_ball(player.global_position+rand_off)
				shoot_ball(player.global_position+rand_off)
			else:
				shoot_ball(player.global_position)
				
		elif stateAtt==attState.ALT:
			rise_att(player.global_position)

	
	increment+=1	


func _on_basic_attack_timeout() -> void:
	if stateBoss==phaseState.PHASE1:
		phase1logic()	
	elif stateBoss==phaseState.PHASE2:
		pass
	elif stateBoss==phaseState.PHASE3:
		pass

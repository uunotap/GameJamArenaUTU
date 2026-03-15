class_name Boss
extends CharacterBody3D
const waterball = preload("res://entities/bossKreatura/attacks/waterball.tscn")
const rising_attack = preload("res://entities/bossKreatura/attacks/ground rise attack.tscn")
const audio = [preload("res://assets/audio/voicelines/grunt0.ogg"), preload("res://assets/audio/voicelines/grunt1.ogg"), preload("res://assets/audio/voicelines/grunt2.ogg"), preload("res://assets/audio/voicelines/grunt3.ogg"), preload("res://assets/audio/voicelines/grunt4.ogg"), preload("res://assets/audio/voicelines/grunt5.ogg"), preload("res://assets/audio/voicelines/grunt6.ogg"), preload("res://assets/audio/voicelines/grunt7.ogg"), preload("res://assets/audio/voicelines/grunt8.ogg"), preload("res://assets/audio/voicelines/special_attack0.ogg"), preload("res://assets/audio/voicelines/special_attack1.ogg"), preload("res://assets/audio/voicelines/special_attack2.ogg"), preload("res://assets/audio/voicelines/new_game.ogg"), preload("res://assets/audio/voicelines/victory.ogg")] 
# 0-9 grunt, 10-12 spec, 13 ng, 14 W
@export var player:Player




enum attState {BASIC, ALT, SWEEP, TRICK}
var stateAtt:attState = attState.BASIC
var increment:int = 0 



var hp:int = 20: set = set_hp
func set_hp(new_hp:int)-> void:
	print( "boss took damage wowza")
	$BSFX.stream = audio[randi() % 9]
	$BSFX.play()
	hp=new_hp
	if hp <=4:
		invulnerability=true
		stateBoss=phaseState.PHASE3
	elif hp <=12:
		invulnerability=true
		stateBoss=phaseState.PHASE2

var invulnerability = false #??

enum phaseState {PHASE1,PHASE2, PHASE3}

@export var stateBoss:phaseState = phaseState.PHASE1: set = set_state

func set_state(new_state: phaseState) -> void:
	invulnerability=false
	stateBoss=new_state
	increment=0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../BGM".play()
	$BSFX.stream = audio[13]
	$BSFX.play()
	$"basic attack".start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot_ball_target(target:Vector3, speedmod:float):
		var instance:WaterBall = waterball.instantiate()
		add_child(instance)
		instance.apply_impulse(global_position.direction_to(target)*20*speedmod)

func scatter_ball(target:Vector3, speedmod:float, offsets:Array[int]):
	for offset1 in offsets:
		for offset2 in offsets:
			#for offset3 in offsets:
			var target_off:Vector3=Vector3(target.x+offset1,target.y,target.z+offset2)
			shoot_ball_target(target_off,speedmod)
	

func shoot_ball_perpendicular(target:Vector3, height:float, speedmod:float):
		var instance:WaterBall = waterball.instantiate()
		add_child(instance)
		
		instance.global_position.y=height
		target=Vector3(target.x,height,target.z)
		var dir_to = instance.global_position.direction_to(target)
		instance.apply_impulse(dir_to*20)
		instance.look_at(target)
		return instance
		
func curve_ball(ball:WaterBall, turn:int):
	
	ball.curve_strength=turn
	ball.curving=true



func rise_att(target:Vector3):
		var instance:Area3D = rising_attack.instantiate()
		add_child(instance)
		instance.global_position = target + Vector3(0,-2, 0)

func scatter_rise(target:Vector3, offsets:Array[int], rand_off:int):
	for offset1 in offsets:
		for offset2 in offsets:
			var target_off:Vector3=Vector3(target.x+offset1-randi_range(-rand_off,rand_off),target.y,target.z+offset2+randi_range(-rand_off, rand_off))
			rise_att(target_off)





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
				shoot_ball_perpendicular(player.global_position,2,1)
				#var rand_off=Vector3(randi_range(-8,8),randi_range(-2,2),randi_range(-8,8))
				#shoot_ball_target(player.global_position+rand_off,1)
				#shoot_ball_target(player.global_position-rand_off,1)
			elif increment % 5 ==0:
				var offset=randi_range(10, 25)
				#scatter_ball(player.global_position, 1, [0, offset, -offset])
			else:
				#shoot_ball_target(player.global_position,2)
				curve_ball(	shoot_ball_perpendicular(player.global_position, 0, 2),100)
				curve_ball(	shoot_ball_perpendicular(player.global_position, 0, 2),-100)
				
		elif stateAtt==attState.ALT:
			var offset=randi_range(10, 30)
			scatter_rise(player.global_position, [0, offset, -offset], 4)
			$BSFX.stream = audio[9 + (randi() % 3)]
			$BSFX.play()
		elif stateAtt==attState.SWEEP:
			var side:bool =randi_range(0,1)
		
	increment+=1	







func teleport_trick(side: bool):
	var dir: int = 1 if side else -1
	var sweep_distance = randi_range(10,30)

	var cur_height = global_position.y
	var side_vector := (player.transform.basis * Vector3(dir, 0, 0)).normalized()
	
	var start_pos = global_position + (side_vector * sweep_distance)
	var end_pos = player.global_position - (side_vector * sweep_distance)

	var tween = create_tween()
	
	end_pos.y=cur_height
	tween.tween_property(self, "global_position", end_pos, 4).set_trans(Tween.TRANS_SINE)



func phase3logic():
	# JUST A COPY OF PHASE 1 ATM
	if attacks >= amount_att:
		attacks=0
		print("attack step", step)
		if step == 1 :
			stateAtt=attState.ALT
			amount_att=5
		elif step == 4 or step == 8:
			stateAtt = attState.TRICK
			amount_att=1
		elif step == 2 or step ==0:
			stateAtt=attState.BASIC
			amount_att=25
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
				shoot_ball_target(player.global_position+rand_off,1)
				shoot_ball_target(player.global_position-rand_off,1)
			elif increment % 5 ==0:
				var offset=randi_range(10, 25)
				scatter_ball(player.global_position, 1, [0, offset, -offset])
			else:
				shoot_ball_target(player.global_position,2)
				
		elif stateAtt==attState.ALT:
			var offset=randi_range(10, 30)
			scatter_rise(player.global_position, [0, offset, -offset], 4)
		elif stateAtt==attState.SWEEP:
			var side:bool =randi_range(0,1)
			
		elif stateAtt==attState.TRICK:
			var side:bool =randi_range(0,1)
			teleport_trick(side)

			
			
		
	increment+=1	




func _on_basic_attack_timeout() -> void:
	if stateBoss==phaseState.PHASE1:
		phase1logic()	
	elif stateBoss==phaseState.PHASE2:
		pass
	elif stateBoss==phaseState.PHASE3:
		phase3logic()

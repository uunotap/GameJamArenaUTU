class_name Player
extends CharacterBody3D


const SPEED = 7.5
const JUMP_VELOCITY = 8
@export var dash_speed: float = 30.0
@export var dash_duration: float = 0.2

const ringBlast = preload("res://entities/player/PlayerProj.tscn")
const audio = [preload("res://assets/audio/swoosh.ogg"), preload("res://assets/audio/splash.ogg")]



#enum moveState {IDLE, RUN, JUMP, DASH}

#var state:moveState = moveState.IDLE: set = set_state

#func set_state(new_state: int) -> void:
#pass

@export var hp_max:int = 5
var hp:int = 5: set = set_health
signal health_changed(old_value, new_value)

func set_health(amount: int) -> void:
	#print(amount)
	var old=hp
	if amount>0:
		if amount<=hp_max:
			hp=amount
		else:
			hp=hp_max
	else:
		hp=amount
		if hp<=0:
			hp=0
			print("PLAYER IS DEAD!")
			$"../BGM".stop()
			#LOSING STATE HERE
	
	emit_signal("health_changed", old, hp)
	



@export var enemy: Node3D
var target: bool = true

var is_dashing: bool=false
var can_dash: bool=true


const MAX_CHARGE = 100
var charge:int =0: set = set_charge
var charging:bool =false
var charged=false
var can_charge=true

func set_charge(amount: int) -> void:
	print(amount)
	if amount>0:
		if amount<=MAX_CHARGE:
			charge=amount
		else:
			charge=MAX_CHARGE
			charged=true
	else:

		if amount<=0:
			charge=0
		else:
			charge=amount
	#emit_signal("charge_changed", charge)

const chargeable_time_MAX = 25
var chargeable_time = 25: set = set_chargeable
func set_chargeable(amount: int) -> void:
	if amount>0:
		if amount<=chargeable_time_MAX:
			chargeable_time=amount
		else:
			chargeable_time=chargeable_time_MAX
			
		if chargeable_time >= 15:
				can_charge=true
	else:
		can_charge=false
		if amount<=0:
			chargeable_time=0
		else:
			chargeable_time=amount
	#emit_signal("charge_changed", charge)


func _on_charge_tick_timeout() -> void:
	if charging:
		charge+=10
		chargeable_time-=1


func _on_charge_loss_timeout() -> void:
	if not charging:
		charge-=1
		chargeable_time+=2




var dash_direction_multiplier: float = 0.0 # 1.0 for right, -1.0 for left

func dash(side: float):
	is_dashing = true
	can_dash = false
	dash_direction_multiplier = side
	$"../SFX".stream = audio[0]
	$"../SFX".play()

# After the duration, stop dashing
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	$DashCooldown.start()


func _on_dash_cooldown_timeout() -> void:
	can_dash=true


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	if charged:
		var instance:RigidBody3D = ringBlast.instantiate()
		add_child(instance)
		instance.apply_impulse(global_position.direction_to(enemy.global_position)*20)
		$"../SFX".stream = audio[1]
		$"../SFX".play()
		charge=0
		charged=false
	
	elif Input.is_action_pressed("attackbutton") and can_charge:
		velocity=Vector3.ZERO
		charging=true
		
	else:
		charging=false	
	
			
	if not charging:
		
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY 

	# Handle Dash Movement
		elif is_dashing and enemy:
			# 1. Get the vector from enemy to player
			var offset = global_position - enemy.global_position

			# 2. Calculate the Tangent (Perpendicular) vector
			var tangent = offset.cross(Vector3.UP).normalized()
			#print(global_position.distance_to(enemy.global_position))
			# 3. Apply velocity along that tangent
			velocity = tangent * dash_speed * dash_direction_multiplier

		elif not is_dashing:
			var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

		# Handle Input
		if Input.is_action_pressed("dash_left") and can_dash:
			dash(1.0) # Clockwise
		if Input.is_action_pressed("dash_right") and can_dash:
			dash(-1.0) # Counter-Clockwise

# Rotation/Looking
	if target and enemy:
		look_at(enemy.global_position)

	move_and_slide()

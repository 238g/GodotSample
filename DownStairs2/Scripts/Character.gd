extends KinematicBody2D

signal gameover

onready var CharacterAnim = get_node("CharacterAnim")
onready var Collision = get_node("Collision")
onready var CollisionTimer = get_node("CollisionTimer")
onready var Effect = get_node("Effect")

var input_direction = 0
var direction = 0

var velocity = Vector2()
var speed_x = 0
var speed_y = 0
var pos = Vector2()
var gravity = 0

const MAX_SPEED = 300
const ACCELERATION = 1000
const DECELERATION = 2000


func _ready():
	gravity = 200
	Collision.set_trigger(false)
	set_process(true)
	CollisionTimer.set_wait_time(global.invincibleTime)
	pass

func _process(delta):
	# OUT OF BORDER
	pos = get_pos()
	if pos.x > global.rightBorder:
		pos.x = global.leftBorder
	if pos.x < global.leftBorder:
		pos.x = global.rightBorder
	set_pos(pos)
	
	# INPUT
	if input_direction:
		direction = input_direction
	
	if Input.is_action_pressed("ui_left"):
		CharacterAnim.set_flip_h(true)
		CharacterAnim.set_animation("Run")
		input_direction = -1
		
	elif Input.is_action_pressed("ui_right"):
		CharacterAnim.set_flip_h(false)
		CharacterAnim.set_animation("Run")
		input_direction = 1
	else:
		if CharacterAnim.get_animation() != "Idle":
			CharacterAnim.set_animation("Idle")
		input_direction = 0
	
	# MOVEMENT
	if input_direction == - direction:
		speed_x /= 3
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	
	speed_y += gravity * delta
	
	velocity.x = speed_x * delta * direction
	velocity.y = speed_y * delta
	
	var movement_remainder = move(velocity)
	
	if is_colliding():
		# COLLISION
		var collisionObject = get_collider()
		if collisionObject.get_name() == "FallOut" || get_pos().y > OS.get_window_size().y:
			gameOver()
			
		if collisionObject.get_name() == "SpikeFloor":
			damage()
		
		# UpperSpikes collision
		if get_pos().y < 55:
			if CollisionTimer.get_time_left() == 0:
				damage()
		
		# MOVEMENT
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed_y = normal.slide(Vector2(0, speed_y)).y
		move(final_movement)
	
	pass

func _on_CollisionTimer_timeout():
	changeInvincible(false)

func gameOver():
	get_tree().set_pause(true)
	global.is_playing = false
	Collision.set_trigger(true)
	gravity = 0
	# When this animation finished, it performs _on_CharacterAnim_finished
	CharacterAnim.set_animation("Dead")

func damage():
	global.life -= 1
	if global.life == 0 && global.is_playing:
		gameOver()
	else:
		changeInvincible(true)

func changeInvincible(state):
	var changeGravity = 100
	# ON
	if state:
		CollisionTimer.start()
		Collision.set_trigger(true)
		gravity -= changeGravity
		Effect.play("Invincible")
	# OFF
	else:
		Collision.set_trigger(false)
		gravity += changeGravity

func _on_CharacterAnim_finished():
	if CharacterAnim.get_animation() == "Dead":
		CharacterAnim.stop()
		emit_signal("gameover")

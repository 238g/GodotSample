extends Area2D

signal explode

#OLD #export var rot_speed = 2.6 #rotation speed
var rot_speed = global.rot_level[global.upgrade_level['rot']]
#OLD #export var thrust = 500 #推力
var thrust = global.thrust_level[global.upgrade_level['thrust']]
export var max_vel = 400 #velocity/速度
export var friction = 0.65 #摩擦/衝突
export (PackedScene) var bullet #onready var bullet = preload("res://scenes/player_bullet.tscn")
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")

var screen_size = Vector2()
var rot = 0 #rotation
var pos = Vector2()
var vel = Vector2() #velocity
var acc = Vector2() #acceleration/加速度
var shield_level = global.shield_max / 2
var shield_up = true

func _ready():
	gun_timer.set_wait_time(global.fire_level[global.upgrade_level['fire_rate']])
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	if shield_up:
		# shield life recovery/regeneration
		#OLD #shield_level = min(shield_level + global.shield_regen * delta, 100)
		shield_level = min(shield_level + global.shield_level[global.upgrade_level['shield_regen']] * delta, global.shield_max)
		
		# shield life 0 and break
		if shield_level <= 0 and shield_up:
			shield_up = false
			shield_level = 0
			get_node("shield").hide()
	
	# input actions
	if Input.is_action_pressed("player_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()
	if Input.is_action_pressed("player_left"):
		rot += rot_speed * delta
	if Input.is_action_pressed("player_right"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("player_thrust"):
		acc = Vector2(thrust, 0).rotated(rot)
		get_node("exhaust").show()
	else:
		acc = Vector2(0, 0)
		get_node("exhaust").hide()
	set_rot(rot - PI/2)
	
	# wrap screen
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	if pos.x > screen_size.width:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.width
	if pos.y > screen_size.height:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.height
	set_pos(pos)

func shoot():
	gun_timer.start() #interval gun shoot
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("muzzle").get_global_pos()) #muzzle/銃口 #get_global_pos!!!

func disable():
	hide()
	set_process(false)
	# TODO why error???
	#??? set_enable_monitoring(false) # collision monitoring
	call_deferred("set_enable_monitoring", false)
	
	
func damage(amount):
	if shield_up:
		shield_level -= amount
	else:
		disable()
		emit_signal("explode")
	
func _on_player_body_enter( body ):
	if is_hidden():
		return
	if body.get_groups().has("asteroids"):
		#print(body.get_name())
		if shield_up:
			body.explode(vel)
			# OLD #shield_level -= global.ast_damage[body.size]
			#print(shield_level)
		#else:
			#emit_signal("explode")

		damage(global.ast_damage[body.size])

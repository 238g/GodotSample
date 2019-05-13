extends Node

#var asteroid = preload("res://scenes/asteroid.tscn")
#var explosion = preload("res://scenes/explosion.tscn")
#var enemy = preload("res://scenes/enemy.tscn")

export (PackedScene) var asteroid
export (PackedScene) var explosion
export (PackedScene) var enemy

onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var HUD = get_node("HUD")
onready var player = get_node("player")
onready var EnemyTimer = get_node("enemy_timer")

func _ready():
	randomize()
	#global.screensize = get_viewport().size
	set_process(true)
	player.connect("explode", self, "explode_player")
	begin_next_level()

# TODO wave 8 -- ERROR
func begin_next_level():
	global.level += 1 # level up => asteroid+=1
	EnemyTimer.stop()
	EnemyTimer.set_wait_time(rand_range(4, 7))
	EnemyTimer.start()
	HUD.show_message("Wave %s" % global.level)
	for i in range(global.level):
		spawn_asteroid("big", spawns.get_children()[i].get_pos(), Vector2(0, 0))

func _process(delta):
	HUD.update(player)
	
	if asteroid_container.get_child_count() == 0:
		begin_next_level()

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	a.init(size, pos, vel) # Need first set pos
	a.connect("explode", self, "explode_asteroid")
	asteroid_container.add_child(a)
	
func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = global.break_pattern[size]
	if newsize:
		# split asteroid
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset #clamp/締め金
			var newvel = (vel + hit_vel.tangent() * offset) * 0.9
			spawn_asteroid(newsize, newpos, newvel)
	
	# explosion animation
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()

# dead player and game over func
func explode_player():
	#player.disable()
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(player.pos)
	expl.set_scale(Vector2(1.5, 1.5))
	expl.set_animation("sonic")
	expl.play()
	HUD.show_message("Game Over")
	get_node("restart_timer").start()

func explode_enemy(pos):
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.set_animation("sonic")
	expl.play()

func _on_restart_timer_timeout():
	global.new_game()

func _on_enemy_timer_timeout():
	# spawn enemy
	var e = enemy.instance()
	e.target = player # bullet target
	e.connect("explode", self, "explode_enemy")
	add_child(e)
	
	# Set next spawn enemy
	EnemyTimer.set_wait_time(rand_range(20, 40))
	EnemyTimer.start()
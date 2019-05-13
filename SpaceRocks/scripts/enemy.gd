extends Area2D

signal explode
signal pulse_timeout # enables pulsed shots

var bullet = preload("res://scenes/enemy_bullet.tscn")

onready var paths = get_node("enemy_paths")
onready var bullet_container = get_node("bullet_container")
onready var shoot_timer = get_node("shoot_timer")
onready var anim = get_node("anim")

var path
var follow
var remote
var speed = 250
var accuracy = 0.1 # 正確さ
var target = null
var health = global.enemy_health
var pulse_timer

func _ready():
	pulse_timer = Timer.new()
	pulse_timer.connect("timeout", self, "emit_pulse_timeout")
	add_child(pulse_timer)
	
	set_process(true)
	randomize()
	path = paths.get_children()[randi() % paths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	remote = Node2D.new()
	follow.add_child(remote)
	
	#TODO
	shoot_timer.set_wait_time(1.5) # vary by level
	shoot_timer.start()

func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)
	set_pos(remote.get_global_pos())
	if follow.get_unit_offset() > 1:
		queue_free()

func damage(amount):
	health -= amount
	anim.play("hit")
	if health <= 0:
		global.score += global.enemy_points
		emit_signal("explode", get_global_pos())
		queue_free()
		
func shoot1():
	var dir = get_global_pos() - target.get_global_pos()
	var b = bullet.instance()
	b.start_at(dir.angle() + rand_range(-accuracy, accuracy), get_global_pos())
	bullet_container.add_child(b)

func shoot3():
	var dir = get_global_pos() - target.get_global_pos()
	for a in [-0.1, 0, 0.1]: # angle
		var b = bullet.instance()
		b.start_at(dir.angle() + a + rand_range(-accuracy, accuracy), get_global_pos())
		bullet_container.add_child(b)

func shoot_pulse(n, delay):
	for i in range(n):
		shoot1()
		pulse_delay(delay)
		yield(self, "pulse_timeout")

func _on_shoot_timer_timeout():
	if target.is_visible():
		# TODO rand attack mode
		shoot_pulse(3, 0.1)
		
func pulse_delay(delay):
	pulse_timer.set_wait_time(delay)
	pulse_timer.set_timer_process_mode(0)
	pulse_timer.start()
	
func emit_pulse_timeout():
	emit_signal("pulse_timeout")
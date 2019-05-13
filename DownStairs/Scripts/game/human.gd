extends RigidBody2D

var nextScene
var root
var currentScene

func _ready():
	nextScene = load("res://Scenes/GameOver.tscn")
	root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() -1)
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var y = get_pos().y
	var mouse_x = get_viewport().get_mouse_pos().x
	set_pos(Vector2(mouse_x, y))
	
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("Spikes"):
			print("Spikes touch")
			gameOver()
			
		if body.is_in_group("SpikeFloor"):
			print("SpikeFloor touch")
			
		if body.get_name() == "FallOut":
			print("FallOut")
			gameOver()
			
func gameOver ():
	print("game over")
	root.add_child(nextScene.instance())
	currentScene.playing = false
	currentScene.queue_free()
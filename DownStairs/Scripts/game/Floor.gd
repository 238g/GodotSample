extends StaticBody2D

var currentScene

var BrickFloor = preload("res://Prefabs/BrickFloor.tscn")
var SpikeFloor = preload("res://Prefabs/SpikeFloor.tscn")
var obstacles

func _ready():
	randomize()
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() -1)
	obstacles = currentScene.get_node("Obstacles")
	set_pos(Vector2(randi() % 450, OS.get_window_size().y))
	set_process(true)
	pass

func _process(delta):
	if currentScene.is_playing() == true:
		if get_pos().y > 0:
			set_pos(get_pos() - Vector2(0, currentScene.SPEED * delta))
		else:
			set_pos(Vector2(randi() % 450, OS.get_window_size().y))
			var randNum = randi() % 11 # 0~10
			
			if randNum == 0:
				obstacles.add_child(BrickFloor.instance())
				queue_free()
			if randNum == 1:
				obstacles.add_child(SpikeFloor.instance())
				queue_free()


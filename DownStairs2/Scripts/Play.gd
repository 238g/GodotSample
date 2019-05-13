extends Node

onready var Character = get_node("Character")
onready var Obstacles = get_node("Obstacles")
onready var GameOverScreen = get_node("GameOverScreen")

func _ready():
	global.life = global.max_life
	global.is_playing = true
	get_tree().set_pause(false)
	set_process(true)
	GameOverScreen.hide()
	Character.connect("gameover", self, "showGameOver")
	pass

func _process(delta):
	if global.is_playing:
		if Obstacles.get_child_count() <= 5:
			if Obstacles.get_children().back().get_pos().y < 400:
				Obstacles.add_child(selectedFloorInstance())
	
func selectedFloorInstance():
	randomize()
	
	var selectedFloor = null
	var randNum = randi() % 11 # 0~10
	
	if randNum == 0:
		var NormalFloor = preload("res://Prefabs/NormalFloor.tscn")
		selectedFloor = NormalFloor.instance()
	elif randNum == 1:
		var SpikeFloor = preload("res://Prefabs/SpikeFloor.tscn")
		selectedFloor = SpikeFloor.instance()
	else:
		var NormalFloor = preload("res://Prefabs/NormalFloor.tscn")
		selectedFloor = NormalFloor.instance()
	
	selectedFloor.set_pos(Vector2(randi() % 375 + 163, OS.get_window_size().y)) # 163~538
	
	return selectedFloor 

func showGameOver():
	GameOverScreen.show()
	
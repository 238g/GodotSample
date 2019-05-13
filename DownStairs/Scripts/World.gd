extends Node2D

export (int, 0, 64) var obstacle_count = 5
export (int, 0, 9999) var SPEED = 200

var BrickFloor = preload("res://Prefabs/BrickFloor.tscn")
var playing = true
var startTime = 0
var nowTime = 0

onready var timeLabel = get_node("Time")
onready var obstacles = get_node("Obstacles")

func _ready():
	set_process(true)
	startTime = OS.get_unix_time()
	pass

func _process(delta):
	if playing:
		nowTime = OS.get_unix_time()
		var elapsed = nowTime - startTime
		var minutes = elapsed / 60
		var seconds = elapsed % 60
		var str_elapsed = "%02d : %02d" % [minutes, seconds]
		timeLabel.set_text(str_elapsed)
		
		var obstacles_ch = obstacles.get_children()
		if obstacles_ch.size() > 0:
			if obstacles_ch.size() == obstacle_count:
				if seconds == 3:
					SPEED = 300
				if seconds == 6:
					SPEED = 400
				if seconds == 9:
					SPEED = 500
					#obstacle_count += 1
				#set_process(false)
				pass
			else:
				if obstacles_ch.back().get_pos().y < OS.get_window_size().y * (obstacle_count - 1) / obstacle_count:
					var BrickFloorInstance = BrickFloor.instance()
					obstacles.add_child(BrickFloorInstance)

	elif (playing == "test"):
		print("aaaaa")
	
func is_playing():
	return playing
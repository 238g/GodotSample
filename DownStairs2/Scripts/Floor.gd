extends StaticBody2D

var speed = 100

func _ready():
	set_process(true)
	pass

func _process(delta):
	if global.is_playing:
		# MOVE or QUEUE
		if get_pos().y > 0:
			set_pos(get_pos() - Vector2(0, speed * delta))
		else:
			queue_free()
extends Node

# game settings
var current_scene = null
var new_scene = null
var is_playing = false
var invincibleTime = 1.2
var leftBorder = 163
var rightBorder = 538

# character settings
var life = 3
var max_life = 3

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var s = ResourceLoader.load(path)
	new_scene = s.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
	
func goto_menu():
	goto_scene("res://Scenes/Menu.tscn")
	
func goto_play():
	goto_scene("res://Scenes/Play.tscn")

#func goto_gameover():
#	goto_scene("res://Scenec/GameOver.tscn")
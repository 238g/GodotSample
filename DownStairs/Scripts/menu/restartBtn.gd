extends TextureButton

export (PackedScene) var nextScene

func _ready():
	pass

func _on_RestartBtn_pressed():
	var root = get_tree().get_root()
	var currentScene = root.get_child(root.get_child_count() -1)
	root.add_child(nextScene.instance())
	currentScene.queue_free()
	pass

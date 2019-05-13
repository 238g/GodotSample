extends TextureButton

onready var BtnText = get_node("BtnText")

func _ready():
	if get_name() == "RestartBtn":
		BtnText.set_text("RESTART")
	if get_name() == "StartBtn":
		BtnText.set_text("START")
		
	pass

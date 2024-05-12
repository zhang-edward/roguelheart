extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(handle_button_pressed)

func handle_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

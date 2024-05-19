extends Button

@export var level_name: String = "PowerUpSelect"
@export var scene: Scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(handle_button_pressed)

func handle_button_pressed() -> void:
	if scene != null:
		scene.switch_scene(level_name)

class_name PowerUpOption

extends PanelContainer

@onready var name_label: RichTextLabel  = $MarginContainer/VBoxContainer/Name
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var description_label: RichTextLabel = $MarginContainer/VBoxContainer/Description

var power_up_data: Dictionary = {}
var power_up_select: PowerUpSelect

func _ready():
	power_up_select = get_node("/root/SceneSwitcher/Victory/PowerUpSelect") as PowerUpSelect

func load_powerup(power_up: Dictionary) -> void:
	power_up_data = power_up
	name_label.text = "[center]" + power_up.name + "[/center]"
	description_label.text = "[center]" + power_up.description + "[/center]"
	
func _on_button_pressed():
	power_up_select.on_select_power_up(power_up_data)

class_name GUI
extends CanvasLayer

@onready var victory_panel = $GUI/PanelContainer
@onready var color_rect = $GUI/ColorRect

func _ready():
	victory_panel.hide()
	color_rect.hide()

func display_victory():
	victory_panel.show()
	color_rect.show()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/PowerUpSelect.tscn")

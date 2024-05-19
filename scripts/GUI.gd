class_name GUI
extends Control

@onready var victory_panel = $PanelContainer
@onready var color_rect = $ColorRect

func _ready():
	victory_panel.hide()
	color_rect.hide()

func display_victory():
	victory_panel.show()
	color_rect.show()

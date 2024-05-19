class_name GUI
extends Control

@onready var victory_panel = $PanelContainer
@onready var color_rect = $ColorRect
@onready var wave_number = $WaveNumber
@onready var main = $"../.."

func _ready():
	victory_panel.hide()
	color_rect.hide()
	wave_number.text = "Wave: " + str(main.level_data.difficulty + 1)
	

func display_victory():
	victory_panel.show()
	color_rect.show()

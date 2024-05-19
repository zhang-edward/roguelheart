class_name Scene
extends Node2D

signal level_changed(level_name)

var level_data: Dictionary = {
	"power_ups": [],
	"difficulty": 0
}

func switch_scene(next_scene_name: String):
	emit_signal("level_changed", next_scene_name)

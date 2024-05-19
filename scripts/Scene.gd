class_name Scene
extends Node2D

signal level_changed(level_name)

func switch_scene(next_scene_name: String):
	print("Switching scene to " + next_scene_name)
	emit_signal("level_changed", next_scene_name)

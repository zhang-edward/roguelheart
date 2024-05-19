class_name SceneSwitcher
extends Node

var next_level = null

@onready var curr_level = $Title
@onready var animation_player = $AnimationPlayer

func _ready():
	curr_level.connect("level_changed", handle_level_changed)
	
func handle_level_changed(next_level_name: String):
	next_level = load("res://scenes/" + next_level_name + ".tscn").instantiate()
	animation_player.play("transition_fade_in")
	
func transfer_data(old_scene, new_scene):
	pass

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"transition_fade_in":
			next_level.hide()
			add_child(next_level)
			next_level.connect("level_changed", handle_level_changed)
			
			curr_level.queue_free()
			curr_level = next_level
			curr_level.show()
			next_level = null
			animation_player.play("transition_fade_out")

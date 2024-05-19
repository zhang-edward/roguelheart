extends Node

var party_data := [
	{
		"health": 50,
		"unit_type": Player.UnitType.MELEE,
		"attack_power": 3,
		"heal_power": 0,
		"attack_speed": 2,
		"move_speed": 100,
		"sprite_frames_path": "res://character_animations/Player1.tres"
	},
	{
		"health": 40,
		"unit_type": Player.UnitType.RANGED,
		"attack_power": 5,
		"heal_power": 0,
		"attack_speed": 1,
		"move_speed": 100,
		"sprite_frames_path": "res://character_animations/Player2.tres"
	},
	{
		"health": 35,
		"unit_type": Player.UnitType.HEALER,
		"attack_power": 0,
		"heal_power": 5,
		"attack_speed": 1,
		"move_speed": 100,
		"sprite_frames_path": "res://character_animations/Player3.tres"
	}
]

var lives := 2

class_name PlayerPartyManager
extends Node2D

"""
The PlayerPartManager class manages the player party. It keeps track of all the players in the party
and the currently selected player, and manages giving orders
"""

var selected_player: Player = null
var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_player(player: Player):
	players.append(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for player in players:
		if player != selected_player:
			player.sprite.modulate = Color(1, 1, 1, 1)
		else:
			player.sprite.modulate = Color(1, 0, 0, 1)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			Engine.time_scale = 0 if Engine.time_scale == 1 else 1

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var clicked_entity = physics_query_entity(get_global_mouse_position())
			if clicked_entity is Player:
				selected_player = clicked_entity
			else:
				selected_player = null
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if selected_player != null:
				var clicked_entity = physics_query_entity(get_global_mouse_position())
				if clicked_entity is Enemy:
					selected_player.set_attack_target(clicked_entity)
				else:
					selected_player.set_move_target(get_global_mouse_position())

# Use physics point query to see if we clicked on a player
func physics_query_entity(pos: Vector2) -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.position = pos
	var result = space_state.intersect_point(query)
	if result.size() == 0:
		return
	return result[0]['collider'].get_parent()

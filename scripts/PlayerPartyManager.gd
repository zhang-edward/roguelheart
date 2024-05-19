class_name PlayerPartyManager
extends Node2D

"""
The PlayerPartManager class manages the player party. It keeps track of all the players in the party
and the currently selected player, and manages giving orders
"""

@export var player_scene: PackedScene
@export var entities_folder: NodePath

var selected_player: Player = null
var players: Array = []

@onready var player_variables: PlayerVariables = get_node("/root/PlayerVariables")

# Called when the node enters the scene tree for the first time.
func _ready():
	var entities = get_node(entities_folder)
	for i in range(player_variables.party_data.size()):
		var player_data = player_variables.party_data[i]
		var new_player = player_scene.instantiate()
		new_player.position = Vector2(i * 100 - 100, 0)
		entities.add_child(new_player)
		new_player.init(player_data)
		add_player(new_player)

func add_player(player: Player):
	players.append(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if all_players_dead():
		if player_variables.lives > 0:
			player_variables.lives -= 1
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

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
				if clicked_entity is Enemy and (selected_player.unit_type == Player.UnitType.MELEE or selected_player.unit_type == Player.UnitType.RANGED):
					selected_player.set_attack_target(clicked_entity)
				elif clicked_entity is Player and (selected_player.unit_type == Player.UnitType.HEALER):
					selected_player.set_attack_target(clicked_entity)
				else:
					var screen_size = get_viewport().get_visible_rect().size
					var move_target = Vector2(get_global_mouse_position().x, max(get_global_mouse_position().y, ( - screen_size.y / 2) + 120))
					selected_player.set_move_target(move_target)

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
	for collision in result:
		var entity = collision['collider'].get_parent()
		if (entity is Player or entity is Enemy) and !entity.is_dead():
			return entity
	return

func all_players_dead():
	for player in players:
		if !player.is_dead():
			return false
	return true

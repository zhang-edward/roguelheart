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
	player.player_selected.connect(on_player_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for player in players:
		if player != selected_player:
			player.modulate = Color(1, 1, 1, 1)
		else:
			player.modulate = Color(1, 0, 0, 1)

func on_player_selected(player: Player):
	if (selected_player == player):
		selected_player = null
	else:
		selected_player = player
		print("Player selected: ", player.name)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if selected_player != null:
				selected_player.set_move_target(get_global_mouse_position())

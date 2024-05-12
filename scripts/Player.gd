class_name Player
extends Node2D

"""
The Player class represents a player-controlled unit in the game.
"""

signal player_selected(player)

@export var speed: float = 100

var _move_target = null
var _area: Area2D
var _sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite = get_node("PlayerSprite") as Sprite2D
	_area = get_node("MousePickableArea") as Area2D
	_area.connect("input_event", handle_area_input_event)
	var player_party_manager: PlayerPartyManager = get_node("/root/Main/PlayerPartyManager") as PlayerPartyManager
	player_party_manager.add_player(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _move_target != null:
		translate((_move_target - position).normalized() * delta * speed)
		# Stop moving if we're close enough to the target
		if (position - _move_target).length() < 1:
			_move_target = null

func set_move_target(target):
	_move_target = target

func handle_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			player_selected.emit(self)

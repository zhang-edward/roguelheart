class_name Player
extends Node2D

"""
The Player class represents a player-controlled unit in the game.
"""

@export var speed: float = 100

var area: Area2D

var _move_target = null
var _sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite = get_node("PlayerSprite") as Sprite2D
	area = get_node("MousePickableArea") as Area2D
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
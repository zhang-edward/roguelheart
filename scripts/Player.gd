class_name Player
extends Node2D

"""
The Player class represents a player-controlled unit in the game.
"""

@export var speed: float = 100

@onready var sprite: Sprite2D = get_node("PlayerSprite") as Sprite2D
@onready var area: Area2D = get_node("MousePickableArea") as Area2D
@onready var _state_machine: StateMachine = get_node("StateMachine")

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_party_manager: PlayerPartyManager = get_node("/root/Main/PlayerPartyManager") as PlayerPartyManager
	player_party_manager.add_player(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_attack_target(target: Node2D):
	_state_machine.transition_to("Attack", {"target": target})

func set_move_target(target: Vector2):
	_state_machine.transition_to("Move", {"target": target})

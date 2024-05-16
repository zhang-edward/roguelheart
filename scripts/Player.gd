class_name Player
extends Node2D

"""
The Player class represents a player-controlled unit in the game.
"""
enum UnitType {
	MELEE,
	RANGED,
	HEALER
}

@export var unit_type: UnitType = UnitType.MELEE

var _health: int = 50

@onready var sprite: AnimatedSprite2D = get_node("Sprite")
@onready var area: Area2D = get_node("MousePickableArea")
@onready var _state_machine: StateMachine = get_node("StateMachine")
@onready var healthbar: ProgressBar = get_node("Healthbar")

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_party_manager: PlayerPartyManager = get_node("/root/Main/PlayerPartyManager") as PlayerPartyManager
	player_party_manager.add_player(self)
	healthbar.value = _health
	healthbar.max_value = _health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_attack_target(target: Node2D):
	match unit_type:
		UnitType.MELEE:
			_state_machine.transition_to("Attack", {"target": target})
		# UnitType.RANGED:
		# 	_state_machine.transition_to("RangedAttack", {"target": target})
		UnitType.HEALER:
			_state_machine.transition_to("Heal", {"target": target})

func set_move_target(target: Vector2):
	_state_machine.transition_to("Move", {"target": target})

# TODO: Move this to an "abstract" base class
func take_damage(amt: int) -> void:
	_health -= amt
	healthbar.value = _health
	if _health <= 0:
		visible = false
		_state_machine.transition_to("Idle")

func heal(amt: int) -> void:
	_health += amt
	healthbar.value = _health

func is_dead() -> bool:
	return _health <= 0

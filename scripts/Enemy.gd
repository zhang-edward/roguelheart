class_name Enemy
extends Node2D

# Called when the node enters the scene tree for the first time.
@onready var _state_machine: StateMachine = get_node("StateMachine")
@onready var healthbar = get_node("Healthbar")
var _health := 10

func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	var x = randi_range( - screen_size.x / 2, screen_size.x / 2)
	var y = randi_range( - screen_size.y / 2, screen_size.y / 2)
	
	position = Vector2(x, y)
	healthbar.value = _health
	healthbar.max_value = _health
	
func set_attack_target(target: Node2D):
	_state_machine.transition_to("Attack", {"target": target})
	
func get_curr_state():
	return _state_machine.state.name

func take_damage(amt: int) -> void:
	_health -= amt
	healthbar.value = _health
	if _health <= 0:
		queue_free()
		visible = false
		_state_machine.transition_to("Idle")

func is_dead() -> bool:
	return _health <= 0

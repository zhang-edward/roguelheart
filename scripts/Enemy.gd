class_name Enemy
extends Node2D

@onready var _state_machine: StateMachine = get_node("StateMachine")

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	var x = randi_range(-screen_size.x / 2, screen_size.x / 2)
	var y = randi_range(-screen_size.y / 2, screen_size.y / 2)
	
	position = Vector2(x, y)
	print("position spawned: " + str(position))
	
func set_attack_target(target: Node2D):
	_state_machine.transition_to("Attack", {"target": target})

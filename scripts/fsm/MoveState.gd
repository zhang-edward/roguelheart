extends State

@export var speed = 100

var _target = null

func physics_update(delta: float) -> void:
	if _target == null:
		state_machine.transition_to("Idle")
		return
	entity.translate((_target - entity.position).normalized() * delta * speed)
	if (entity.position - _target).length() < 1:
		state_machine.transition_to("Idle")

func enter(msg:={}) -> void:
	_target = msg.target

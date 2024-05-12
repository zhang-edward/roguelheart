extends State

@export var speed = 100

const ATTACK_TARGET_OFFSET: Vector2 = Vector2( - 50, 0)
const MIN_ATTACK_DISTANCE: float = 5
const MAX_ATTACK_DISTANCE: float = 20

var _target = null

func physics_update(delta: float) -> void:
	if _target != null:
		var attack_target_pos = _target.position + ATTACK_TARGET_OFFSET
		if (entity.position - attack_target_pos).length() < MIN_ATTACK_DISTANCE:
			print("Attacking target")
		else:
			entity.translate((_target.position - entity.position).normalized() * delta * speed)

func enter(msg:={}) -> void:
	_target = msg.target

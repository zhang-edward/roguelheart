extends State

@export var move_speed = 100

const ATTACK_TARGET_OFFSET: float = 50
const MIN_ATTACK_DISTANCE: float = 5

var _target = null
# If approaching target from the left, then attack offset position will be on the left
# Otherwise, it will be on the right
var _approach_dir := Vector2.RIGHT

func _ready() -> void:
	pass
	
func physics_update(delta: float) -> void:
	if _target == null or _target.is_dead():
		state_machine.transition_to("Idle")
		return
	_approach_dir = Vector2.RIGHT if _target.position.x < entity.position.x else Vector2.LEFT

	var attack_target_pos = _target.position + (_approach_dir * ATTACK_TARGET_OFFSET)
	entity.translate((attack_target_pos - entity.position).normalized() * delta * move_speed)
	if (entity.position - attack_target_pos).length() < MIN_ATTACK_DISTANCE:
		state_machine.transition_to("Attack", {"target": _target})

func enter(msg:={}) -> void:
	_target = msg.target
	sprite.play("default")

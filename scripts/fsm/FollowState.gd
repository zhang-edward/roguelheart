extends State

@export var move_speed = 100

const ATTACK_TARGET_OFFSET: float = 50
const MIN_ATTACK_DISTANCE: float = 5

var _target = null
# If approaching target from the left, then attack offset position will be on the left
# Otherwise, it will be on the right
var _approach_dir := Vector2.RIGHT
var _line_to_dest: Line2D = null

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
		
	if entity is Player:	
		draw_line_to_target()

func enter(msg:={}) -> void:
	_target = msg.target
	sprite.play("default")
	
func exit() -> void:
	_line_to_dest.queue_free()
	
func draw_line_to_target():
	if _line_to_dest == null:
		_line_to_dest = Line2D.new()
		add_child(_line_to_dest)
		_line_to_dest.width = 10.0
		_line_to_dest.default_color = Color(1, 0, 0, 1)
	else:
		_line_to_dest.clear_points()
	_line_to_dest.add_point(Vector2(entity.position.x, entity.position.y))
	_line_to_dest.add_point(Vector2(_target.position.x, _target.position.y))

extends State

@export var marker: PackedScene

var _target = null
var _curr_dest_marker: Node = null
var _line_to_dest: Line2D = null

func physics_update(delta: float) -> void:
	if _target == null:
		state_machine.transition_to("Idle")
		return
	var dir = (_target - entity.position).normalized();
	sprite.flip_h = dir.x < 0
	entity.translate(dir * delta * entity.move_speed)
	if (entity.position - _target).length() < 1:
		state_machine.transition_to("Idle")
	if marker != null:
		drawLineToTarget()

func enter(msg:={}) -> void:
	_target = msg.target
	if sprite.sprite_frames.has_animation("move"):
		sprite.play("move")
	# Display a move target marker
	if marker != null:
		_curr_dest_marker = marker.instantiate() as Node
		_curr_dest_marker.z_index = (entity as Player).z_index - 1
		add_child(_curr_dest_marker)
		_curr_dest_marker.position = Vector2(_target.x, _target.y)

func exit() -> void:
	if _curr_dest_marker != null:
		_curr_dest_marker.queue_free()
	if _line_to_dest != null:
		_line_to_dest.queue_free()
	
func drawLineToTarget():
	if _line_to_dest == null:
		_line_to_dest = Line2D.new()
		add_child(_line_to_dest)
		_line_to_dest.z_index = (entity as Player).z_index - 1
		_line_to_dest.width = 10.0
		_line_to_dest.default_color = Color(0, 0.71, 0, 1)
	else:
		_line_to_dest.clear_points()
	_line_to_dest.add_point(Vector2(entity.position.x, entity.position.y))
	_line_to_dest.add_point(Vector2(_target.x, _target.y))

class_name Projectile

extends Node2D

var _travel_timer: SceneTreeTimer
var _target
var _start_position: Vector2
var _total_time: float
var _damage: int

func init(travel_timer: SceneTreeTimer, target, start_position: Vector2, total_time: float, damage: int):
	_travel_timer = travel_timer
	_target = target
	_start_position = start_position
	_total_time = total_time
	_damage = damage

func _physics_process(_delta: float):
	if !is_instance_valid(_target):
		queue_free()
		return

	var progress = 1 - (_travel_timer.time_left / _total_time)
	position = lerp(_start_position, _target.position, progress)

	if progress >= 1:
		_target.take_damage(_damage, null)
		queue_free()

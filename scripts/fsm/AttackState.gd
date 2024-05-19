class_name AttackState
extends State

const ATTACK_ANIMATION_NAME = "action"
const ATTACK_TARGET_OFFSET: float = 50
const MAX_ATTACK_DISTANCE: float = 20

var _target = null
# If approaching target from the left, then attack offset position will be on the left
# Otherwise, it will be on the right
var _approach_dir := Vector2.RIGHT
var _attack_anim_speed_factor: float

func _ready() -> void:
	sprite.frame_changed.connect(attack)
	var attack_anim_duration = get_animation_duration(sprite.sprite_frames, ATTACK_ANIMATION_NAME)
	var attack_interval = 1 / entity.attack_speed
	_attack_anim_speed_factor = attack_anim_duration / attack_interval
	# Aggro behavior
	if entity is Enemy:
		entity.on_attacked.connect(on_attacked)
	
func physics_update(_delta: float) -> void:
	if _target == null or _target.is_dead():
		state_machine.transition_to("Idle")
		return
	# Target has to be within MIN_ATTACK_DISTANCE to start attacking
	var attack_target_pos = _target.position + (_approach_dir * ATTACK_TARGET_OFFSET)
	sprite.flip_h = _approach_dir.x > 0
	# Target has to be outside MAX_ATTACK_DISTANCE to stop attacking
	if (entity.position - attack_target_pos).length() > MAX_ATTACK_DISTANCE:
		state_machine.transition_to("Follow", {"target": _target})
		
	# Highlight target if the current player is selected
	if entity is Player:
		entity.highlight_target(_target)
			
func exit() -> void:
	if _target != null and _target is Enemy:
		var target_enemy = _target as Enemy
		if entity.is_selected():
			target_enemy.remove_highlight()

func enter(msg:={}) -> void:
	_target = msg.target
	_target.aggro(entity)
	_approach_dir = Vector2.RIGHT if msg.target.position.x < entity.position.x else Vector2.LEFT
	sprite.play(ATTACK_ANIMATION_NAME, _attack_anim_speed_factor)

func attack() -> void:
	# TODO: make attack frame configurable instead of always being frame 1
	if _target == null or sprite.animation != ATTACK_ANIMATION_NAME or sprite.frame != 1:
		return
	var attack_target_pos = _target.position + (_approach_dir * ATTACK_TARGET_OFFSET)
	if (entity.position - attack_target_pos).length() < MAX_ATTACK_DISTANCE:
		_target.take_damage(entity.attack_power, entity)

# Gets the duration of an animation in seconds. Used to scale animation speed to explicitly set attack speed
func get_animation_duration(sprite_frames: SpriteFrames, animation_name: StringName) -> float:
	# Calculate the duration of each frame at the current playing speed
	var fps := sprite_frames.get_animation_speed(animation_name)
	var playing_speed = sprite.speed_scale;
	var frame_duration = 1.0 / (fps * playing_speed)
	# Final animation duration = sum of all frame durations
	var anim_duration = 0.0
	for i in range(sprite_frames.get_frame_count(animation_name)):
		var absolute_frame_duration = sprite_frames.get_frame_duration(animation_name, i) * frame_duration
		anim_duration += absolute_frame_duration
	return anim_duration

func on_attacked(from: Player):
	if from == null or _target == null:
		return
	# Target entity with more health
	if from._health > _target._health:
		_target = from

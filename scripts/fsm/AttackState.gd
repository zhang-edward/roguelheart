extends State

@export var move_speed = 100
@export var attack_interval = 1

const ATTACK_ANIMATION_NAME = "attack"
const ATTACK_TARGET_OFFSET: Vector2 = Vector2(0, 0)
const MIN_ATTACK_DISTANCE: float = 5
const MAX_ATTACK_DISTANCE: float = 20

var _target = null
var _attack_anim_speed_factor: float

func _ready() -> void:
	await entity.ready
	sprite.frame_changed.connect(attack)
	var attack_anim_duration = get_animation_duration(sprite.sprite_frames, ATTACK_ANIMATION_NAME)
	_attack_anim_speed_factor = attack_anim_duration / attack_interval

func physics_update(delta: float) -> void:
	if _target == null:
		state_machine.transition_to("Idle")

	var attack_target_pos = _target.position + ATTACK_TARGET_OFFSET
	if (entity.position - attack_target_pos).length() < MIN_ATTACK_DISTANCE:
		sprite.play("attack", _attack_anim_speed_factor)
	else:
		sprite.play("default")
		entity.translate((_target.position - entity.position).normalized() * delta * move_speed)

func enter(msg:={}) -> void:
	_target = msg.target

func attack() -> void:
	# TODO: make attack frame configurable instead of always being frame 1
	if _target == null or sprite.animation != "attack" or sprite.frame != 1:
		return
	var attack_target_pos = _target.position + ATTACK_TARGET_OFFSET
	if (entity.position - attack_target_pos).length() < MAX_ATTACK_DISTANCE:
		print(entity.name + " attacks " + _target.name + "!");
		# _target.take_damage(1)

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

extends State

@export var attack_interval = 1
@export var attack_damage = 5
@export var projectile_travel_speed = 50

const ATTACK_ANIMATION_NAME = "action"

var _target = null
# If approaching target from the left, then attack offset position will be on the left
# Otherwise, it will be on the right
var _approach_dir := Vector2.RIGHT
var _attack_anim_speed_factor: float
var _projectile: PackedScene = preload ("res://prefab/Projectile.tscn")

func _ready() -> void:
	sprite.frame_changed.connect(attack)
	var attack_anim_duration = get_animation_duration(sprite.sprite_frames, ATTACK_ANIMATION_NAME)
	_attack_anim_speed_factor = attack_anim_duration / attack_interval
	
func physics_update(_delta: float) -> void:
	if _target == null or _target.is_dead():
		state_machine.transition_to("Idle")
		return

func enter(msg:={}) -> void:
	_target = msg.target
	_approach_dir = Vector2.RIGHT if msg.target.position.x < entity.position.x else Vector2.LEFT
	sprite.play(ATTACK_ANIMATION_NAME, _attack_anim_speed_factor)

func attack() -> void:
	# TODO: make attack frame configurable instead of always being frame 1
	if _target == null or sprite.animation != ATTACK_ANIMATION_NAME or sprite.frame != 1:
		return

	# Create projectile travel timer
	var projectile_travel_time = entity.position.distance_to(_target.position) / projectile_travel_speed
	var timer = entity.get_tree().create_timer(projectile_travel_time, false)
	
	# Spawn projectile
	var projectile_instance = _projectile.instantiate()
	entity.get_parent().add_child(projectile_instance)
	projectile_instance.init(timer, _target, entity.position, projectile_travel_time, attack_damage)

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

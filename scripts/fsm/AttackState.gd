extends State

@export var speed = 100

const ATTACK_TARGET_OFFSET: Vector2 = Vector2(0, 0)
const MIN_ATTACK_DISTANCE: float = 5
const MAX_ATTACK_DISTANCE: float = 20

var _target = null
var attacking = false

@onready var attack_timer: Timer = get_node("AttackTimer")

func _ready() -> void:
	attack_timer.timeout.connect(attack)

func physics_update(delta: float) -> void:
	if _target == null:
		state_machine.transition_to("Idle")

	var attack_target_pos = _target.position + ATTACK_TARGET_OFFSET
	if (entity.position - attack_target_pos).length() < MIN_ATTACK_DISTANCE:
		attacking = true
	else:
		attacking = false
		entity.translate((_target.position - entity.position).normalized() * delta * speed)

	if attacking and attack_timer.is_stopped():
		attack_timer.start()

func enter(msg:={}) -> void:
	_target = msg.target

func attack() -> void:
	if _target == null:
		return
	var attack_target_pos = _target.position + ATTACK_TARGET_OFFSET
	if (entity.position - attack_target_pos).length() < MAX_ATTACK_DISTANCE:
		print(entity.name + " attacks " + _target.name + "!");
		# _target.take_damage(1)

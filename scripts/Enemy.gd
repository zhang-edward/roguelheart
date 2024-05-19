class_name Enemy
extends Node2D

signal on_died(enemy: Enemy)
signal on_attacked(from: Player)

# Called when the node enters the scene tree for the first time.
@onready var _state_machine: StateMachine = get_node("StateMachine")
@onready var healthbar: ProgressBar = get_node("Healthbar")
@onready var sprite: AnimatedSprite2D = get_node("Sprite")

var _health := 10
var attack_power: int = 5
var heal_power: int = 10
var attack_speed: int = 1
var move_speed: int = 100

func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	var x = randi_range( - screen_size.x / 2, screen_size.x / 2)
	var y = randi_range( - screen_size.y / 2, screen_size.y / 2) + 120
	
	position = Vector2(x, y)
	
func init(config: Dictionary):
	healthbar.value = config.health
	healthbar.max_value = config.health
	_health = config.health
	attack_power = config.attack_power
	heal_power = config.heal_power
	attack_speed = config.attack_speed
	move_speed = config.move_speed
	# TODO: load sprite frames
	# sprite.sprite_frames = load(config.sprite_frames_path) 

func set_attack_target(target: Node2D):
	_state_machine.transition_to("Attack", {"target": target})
	
func get_curr_state():
	return _state_machine.state.name

func take_damage(amt: int, from) -> void:
	$BloodParticles.restart()
	$BloodParticles.emitting = true
	on_attacked.emit(from)
	_health -= amt
	healthbar.value = _health
	if _health <= 0:
		queue_free()
		on_died.emit(self)

func aggro(from: Node2D):
	on_attacked.emit(from)
		
func highlight(color: Color):
	var shader_material = sprite.material as ShaderMaterial
	shader_material.set_shader_parameter('width', 1)
	shader_material.set_shader_parameter('color', color)
	
func remove_highlight():
	var shader_material = sprite.material as ShaderMaterial
	shader_material.set_shader_parameter('width', 0)

func is_dead() -> bool:
	return _health <= 0

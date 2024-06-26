class_name Player
extends Node2D

"""
The Player class represents a player-controlled unit in the game.
"""
enum UnitType {
	MELEE,
	RANGED,
	HEALER
}

@export var unit_type: UnitType = UnitType.MELEE

var _health: int = 50
var _is_hovering: bool = false
var _line_to_enemy: Line2D = null
var _line_to_ally: Line2D = null
var _player_party_manager: PlayerPartyManager = null

var attack_power: int = 5
var heal_power: int = 10
var attack_speed: int = 1
var move_speed: int = 100

@onready var sprite: AnimatedSprite2D = get_node("Sprite")
@onready var area: Area2D = get_node("MousePickableArea")
@onready var _state_machine: StateMachine = get_node("StateMachine")
@onready var healthbar: ProgressBar = get_node("Healthbar")

# Called when the node enters the scene tree for the first time.
func _ready():
	_player_party_manager = get_node("/root/SceneSwitcher/Main/PlayerPartyManager") as PlayerPartyManager
	healthbar.value = _health
	healthbar.max_value = _health
	var _material = sprite.material as ShaderMaterial
	_material.set_shader_parameter('width', 0)

func init(config: Dictionary, power_ups: Array):
	_health = config.health
	unit_type = config.unit_type
	attack_power = config.attack_power
	heal_power = config.heal_power
	attack_speed = config.attack_speed
	move_speed = config.move_speed
	sprite.sprite_frames = load(config.sprite_frames_path)
	apply_power_ups(power_ups)
	
func apply_power_ups(power_ups: Array):
	for power_up in power_ups:
		match power_up.passive_power_up_stat:
			PowerUpSelect.PassivePowerUpStat.ATTACK_POWER:
				attack_power += 1
			PowerUpSelect.PassivePowerUpStat.HEAL_POWER:
				heal_power += 1
			PowerUpSelect.PassivePowerUpStat.MOVEMENT_SPEED:
				move_speed += 10
			PowerUpSelect.PassivePowerUpStat.HP:
				_health += 5
	print(_health)
	print(attack_power)
	print(heal_power)
	print(move_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var _material = sprite.material as ShaderMaterial
	if _player_party_manager.selected_player == self:
		_material.set_shader_parameter('width', 1)
		_material.set_shader_parameter('color', Color(0, 1.0, 0, 1))
	else:
		if !_is_hovering:
			_material.set_shader_parameter('width', 0)

func set_attack_target(target: Node2D):
	match unit_type:
		UnitType.MELEE:
			_state_machine.transition_to("Attack", {"target": target})
		UnitType.RANGED:
			_state_machine.transition_to("RangeAttack", {"target": target})
		UnitType.HEALER:
			_state_machine.transition_to("Heal", {"target": target})

func set_move_target(target: Vector2):
	_state_machine.transition_to("Move", {"target": target})

# TODO: Move this to an "abstract" base class
func take_damage(amt: int, _from) -> void:
	$BloodParticles.restart()
	$BloodParticles.emitting = true
	_health -= amt
	healthbar.value = _health
	if _health <= 0:
		visible = false
		_state_machine.transition_to("Idle")

func aggro(_from: Node2D):
	pass

func heal(amt: int) -> void:
	_health += amt
	healthbar.value = _health
	$HealParticles.restart()
	$HealParticles.emitting = true

func is_dead() -> bool:
	return _health <= 0
	
func is_selected() -> bool:
	return _player_party_manager.selected_player == self

func _on_mouse_pickable_area_mouse_shape_entered(_shape_idx):
	_is_hovering = true
	sprite.material.set_shader_parameter('color', Color(1, 0.855, 0, 1))
	sprite.material.set_shader_parameter('width', 1)

func _on_mouse_pickable_area_mouse_shape_exited(_shape_idx):
	_is_hovering = false
	
func highlight_target(enemy: Enemy):
	enemy.highlight(Color(1.0, 0, 0, 1.0))
	
func clear_line_to_enemy():
	if _line_to_enemy != null:
		_line_to_enemy.queue_free()
		
func clear_line_to_ally():
	if _line_to_ally != null:
		_line_to_ally.queue_free()

func draw_line_to_enemy(enemy: Enemy):
	if _line_to_enemy == null:
		_line_to_enemy = draw_new_line(Color(1.0, 0, 0, 1.0))
	else:
		if is_dead():
			_line_to_enemy.hide()
		else:
			_line_to_enemy.show()
			_line_to_enemy.clear_points()
			_line_to_enemy.add_point(Vector2(position.x, position.y))
			_line_to_enemy.add_point(Vector2(enemy.position.x, enemy.position.y))


func draw_line_to_ally(player: Player):

	if _line_to_ally == null:
		_line_to_ally = draw_new_line(Color.DEEP_SKY_BLUE)
	else:
		if is_dead():
			_line_to_ally.hide()
		else:
			_line_to_ally.show()
			_line_to_ally.clear_points()
			_line_to_ally.add_point(Vector2(position.x, position.y))
			_line_to_ally.add_point(Vector2(player.position.x, player.position.y))

func draw_new_line(color: Color) -> Line2D:
	var new_line = Line2D.new()
	add_sibling(new_line)
	new_line.z_index = self.z_index - 1
	new_line.width = 10.0
	new_line.default_color = color
	new_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	new_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	return new_line

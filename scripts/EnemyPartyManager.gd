class_name EnemyPartyManager
extends Node2D

const MIN_ENEMIES = 2
const MAX_ENEMIES = 4
const ENEMY_DATA = {
	"health": 50,
	"attack_power": 2,
	"heal_power": 0,
	"attack_speed": 0.5,
	"move_speed": 50,
}

@export var enemy_scene: PackedScene

static var enemies: Array = []
var player_party_manager: PlayerPartyManager

# Called when the node enters the scene tree for the first time.
func _ready():
	var num_enemies = randi_range(MIN_ENEMIES, MAX_ENEMIES)
	
	player_party_manager = get_node("/root/Main/PlayerPartyManager") as PlayerPartyManager
	var players = player_party_manager.players
	for i in range(num_enemies):
		var enemy = enemy_scene.instantiate() as Enemy
		add_child(enemy)
		enemy.init(ENEMY_DATA)
		enemy.set_attack_target(players.pick_random())
		enemies.append(enemy)
		enemy.on_died.connect(on_enemy_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	var living_players = player_party_manager.players.filter(func(p: Player): return !p.is_dead())
	
	if living_players.size() > 0:
		for enemy in enemies:
			if !is_instance_valid(enemy):
				continue
			if enemy.get_curr_state() == "Idle":
				enemy.set_attack_target(living_players.pick_random())

	if all_enemies_dead():
		get_tree().reload_current_scene()

func all_enemies_dead():
	for enemy in enemies:
		if !is_instance_valid(enemy):
			continue
		if !enemy.is_dead():
			return false
	return true

func on_enemy_died(enemy: Enemy):
	enemies.erase(enemy)

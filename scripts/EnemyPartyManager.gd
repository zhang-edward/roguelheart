extends Node2D

const MIN_ENEMIES = 2
const MAX_ENEMIES = 4

@export var enemy_scene: PackedScene
var enemies: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var num_enemies = randi_range(MIN_ENEMIES, MAX_ENEMIES)
	print("num enemies spawned: " + str(num_enemies))
	
	var player_party_manager: PlayerPartyManager = get_node("/root/Main/PlayerPartyManager") as PlayerPartyManager
	var players = player_party_manager.players
	for i in range(num_enemies):
		var enemy = enemy_scene.instantiate() as Enemy
		add_child(enemy)
		enemy.set_attack_target(players.pick_random())
		enemies.append(enemy)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

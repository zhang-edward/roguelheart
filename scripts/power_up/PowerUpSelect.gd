class_name PowerUpSelect
extends Node

enum PowerUpType {
	PASSIVE,
	ACTIVE
}

enum PassivePowerUpStat {
	ATTACK_POWER,
	HEAL_POWER,
	HP,
	MOVEMENT_SPEED,
	ATTACK_SPEED
}

var power_up_data := [
	{
		"name": "Attack Up",
		"description": "Increase attack power of attacking units by 1",
		"power_up_type": PowerUpType.PASSIVE,
		"passive_power_up_stat": PassivePowerUpStat.ATTACK_POWER
	},
	{
		"name": "Heal Up",
		"description": "Increase heal power of healing units by 1",
		"power_up_type": PowerUpType.PASSIVE,
		"passive_power_up_stat": PassivePowerUpStat.HEAL_POWER
	},
	{
		"name": "HP Up",
		"description": "Increase HP of all units by 5",
		"power_up_type": PowerUpType.PASSIVE,
		"passive_power_up_stat": PassivePowerUpStat.HP
	},
	{
		"name": "Movement Speed Up",
		"description": "Increase movement speed of all units by 10",
		"power_up_type": PowerUpType.PASSIVE,
		"passive_power_up_stat": PassivePowerUpStat.MOVEMENT_SPEED
	}
]
@onready var victory: Scene = $".."

@onready var power_up_options: Array[PowerUpOption] = [
	$CanvasLayer/Control/HBoxContainer/PowerUpOption,
	$CanvasLayer/Control/HBoxContainer/PowerUpOption2,
	$CanvasLayer/Control/HBoxContainer/PowerUpOption3
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var power_ups = power_up_data
	power_ups.shuffle()
	for i in range(0, power_up_options.size()):
		var power_up_option = power_up_options[i]
		var power_up = power_ups[i]
		power_up_option.load_powerup(power_up)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_select_power_up(power_up_data: Dictionary):
	victory.level_data.power_ups.append(power_up_data)
	victory.level_data.difficulty += 1
	victory.switch_scene("Main")
	pass

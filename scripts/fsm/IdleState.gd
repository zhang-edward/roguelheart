extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	# If enemy nearby, attack it
	if entity is Player and entity.unit_type == Player.UnitType.MELEE:
		for enemy in EnemyPartyManager.enemies:
			if (enemy.global_position - sprite.global_position).length() < 150:
				state_machine.transition_to("Attack", {"target": enemy})
				break

func enter(_msg:={}) -> void:
	sprite.play("default")
	pass

func exit() -> void:
	pass

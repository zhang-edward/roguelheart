extends RichTextLabel

@onready var player_variables = get_node("/root/PlayerVariables")

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Lives: " + str(player_variables.lives)

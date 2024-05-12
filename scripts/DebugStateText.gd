extends RichTextLabel

@onready var state_machine: StateMachine = get_parent().get_node("StateMachine")

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "[center]" + state_machine.state.name + "[/center]"
	state_machine.transitioned.connect(on_transitioned)

func on_transitioned(state_name: String):
	text = "[center]" + state_name + "[/center]"

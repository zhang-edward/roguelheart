class_name Enemy
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		translate(Vector2(1, 0) * delta * 100)
	if Input.is_action_pressed("ui_left"):
		translate(Vector2( - 1, 0) * delta * 100)
	if Input.is_action_pressed("ui_up"):
		translate(Vector2(0, -1) * delta * 100)
	if Input.is_action_pressed("ui_down"):
		translate(Vector2(0, 1) * delta * 100)

extends Node2D

signal power_executed(position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		emit_signal("power_executed", get_global_mouse_position())
		queue_free()

func quit_power_cursor():
	queue_free()
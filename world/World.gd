extends Node2D

var ExpulsionEffect = preload("res://world/ExpulsionEffect.tscn")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_PlayerArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_click"):
		#Instantiate a expulsion effect
		var expulsion_effect = ExpulsionEffect.instance()
		expulsion_effect.position = get_global_mouse_position()
		add_child(expulsion_effect)


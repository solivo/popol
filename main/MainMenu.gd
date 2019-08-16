extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ExitButton_pressed() -> void:
	#Quit the game
	get_tree().quit()


func _on_PlayButton_pressed() -> void:
	#Hide the main menu
	visible = false
	emit_signal("start_game")

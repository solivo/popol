extends Control

signal start_game(tutorial_enabled)

#Options variables
var tutorial_enabled = true

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
	emit_signal("start_game", tutorial_enabled)
	$ClickAudio.play()
	$BackgroundMusic.stop()


func _on_TutorialCheckbox_toggled(button_pressed: bool) -> void:
	tutorial_enabled = button_pressed
	$ClickAudio.play()


func _on_SoundCheckbox_toggled(button_pressed: bool) -> void:
	$ClickAudio.play()
	if not button_pressed:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)

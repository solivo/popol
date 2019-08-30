extends Control

signal start_game(tutorial_enabled)

#Options variables
var tutorial_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_bgm("background_music.ogg")


func _on_ExitButton_pressed() -> void:
	#Quit the game
	get_tree().quit()


func _on_PlayButton_pressed() -> void:
	#Hide the main menu
	visible = false
	emit_signal("start_game", tutorial_enabled)
	SoundManager.play_se("click")


func _on_TutorialCheckbox_toggled(button_pressed: bool) -> void:
	tutorial_enabled = button_pressed
	SoundManager.play_se("click")


func _on_SoundCheckbox_toggled(button_pressed: bool) -> void:
	SoundManager.play_se("click")
	if not button_pressed:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)

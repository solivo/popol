extends Control


var end_round = 0 #Store the end round 

#Connection to the World Scene
signal unit_panel_pressed #Attemps to create a new unit 
signal meteor_panel_pressed #Attemps to create a new meteor power
signal arrow_panel_pressed #Attemps to create a new arrow power
signal meteor_power_clicked
signal arrow_power_pressed
signal restart_button_pressed
signal cloud_area_entered #Trigger when the cursor is over the cloud area
signal cloud_area_exited
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shortcut_unit"):
		emit_signal("unit_panel_pressed")
		SoundManager.play_se("click")
	elif event.is_action_pressed("shortcut_arrow"):
		emit_signal("arrow_panel_pressed")
		SoundManager.play_se("click")
	elif event.is_action_pressed("shortcut_meteor"):
		emit_signal("meteor_panel_pressed")
		SoundManager.play_se("click")
	elif event.is_action_pressed("shortcut_meteor_power"):
		emit_signal("meteor_power_clicked")
		SoundManager.play_se("click")
	elif event.is_action_pressed("shorcut_arrow_power"):
		emit_signal("arrow_power_pressed")
		SoundManager.play_se("click")

func show_GUI():
	visible = true

func hide_GUI():
	visible = false

func update_corn_amount_panel(corn_amount):
	$ResourcesPanel/MarginContainer/CornAmountPanel/CornAmountLabel.text = str(corn_amount)
	
func update_units_amount(current_units):
	if current_units < 0:
		current_units = 0
	$MainPanel/MarginContainer/UnitsPanel/UnitsAmountLabel.text = str(current_units)

func update_round_seconds(current_seconds):
	if current_seconds < 10:
		current_seconds = "0" +str(current_seconds)
	else:
		current_seconds = str(current_seconds)
	$RoundPanelContainer/RoundPanel/SecondsLabel.text = str(current_seconds)

func update_round_minutes(current_minutes):
	$RoundPanelContainer/RoundPanel/MinutesLabel.text = str(current_minutes)

func update_round_count(current_round):
	$RoundPanelContainer/RoundPanel/RoundCountLabel.text = str(current_round)

func disable_unit_panel():
	$MainPanel/MarginContainer/UnitsPanel.disabled = true

func enable_unit_panel():
	$MainPanel/MarginContainer/UnitsPanel.disabled = false

func enable_arrow_power():
	$PowersPanelContainer/PowersPanel/ArrowPowerButton.disabled = false

func disable_arrow_power():
	$PowersPanelContainer/PowersPanel/ArrowPowerButton.disabled = true


func enable_meteor_power():
	$PowersPanelContainer/PowersPanel/MeteorPowerButton.disabled = false

func disable_meteor_power():
	$PowersPanelContainer/PowersPanel/MeteorPowerButton.disabled = true

func disable_meteor_panel():
	$MainPanel/MeteorsPanelContainer/MeteorPanel.disabled = true

func enable_meteor_panel():
	$MainPanel/MeteorsPanelContainer/MeteorPanel.disabled = false

func disable_arrow_panel():
	$MainPanel/ArrowsPanelContainer/ArrowsPanel.disabled = true

func enable_arrow_panel():
	$MainPanel/ArrowsPanelContainer/ArrowsPanel.disabled = false

func update_meteors_amount(current_meteors):
	$MainPanel/MeteorsPanelContainer/MeteorPanel/MeteorsAmountLabel.text = str(current_meteors)

func update_arrows_amount(current_arrows):
	$MainPanel/ArrowsPanelContainer/ArrowsPanel/ArrowsAmountLabel.text = str(current_arrows)
	
func announce_round(current_round):
	$RoundAnnouncerContainer/RoundAnnouncerLabel.text = "Round " + str(current_round)
	$RoundAnnouncerContainer/AnimationPlayer.play("round_announcing")

func announce_game_over():
	$GameOverAnnouncer/AnimationPlayer.play("game_over_announcing")

func show_game_over_panel():
	$GameOverPanel/Background/RoundsSurvivedLabel.text = "Rounds survived: " + str(end_round)
	$GameOverPanel.visible = true

func hide_game_over_panel():
	$GameOverPanel.visible = false
	

func _on_World_corn_amount_changed(corn_amount) -> void:
	update_corn_amount_panel(corn_amount)


func _on_World_units_amount_changed(units_amount) -> void:
	update_units_amount(units_amount)


func _on_World_progress_unit_creation_changed(current_time, duration) -> void:
	$MainPanel/MarginContainer/UnitsPanel/TextureProgress.max_value = duration
	$MainPanel/MarginContainer/UnitsPanel/TextureProgress.value = current_time
	if current_time == duration:
		$MainPanel/MarginContainer/UnitsPanel/TextureProgress.value = 0


func _on_World_round_minutes_changed(current_minutes) -> void:
	update_round_minutes(current_minutes)


func _on_World_round_seconds_changed(current_seconds) -> void:
	update_round_seconds(current_seconds)


func _on_World_round_changed(current_round) -> void:
	update_round_count(current_round)
	announce_round(current_round)

func _on_World_unit_panel_disabled() -> void:
	disable_unit_panel()

func _on_World_unit_panel_enabled() -> void:
	enable_unit_panel()


func _on_MeteorPower_pressed() -> void:
	emit_signal("meteor_power_clicked")
	SoundManager.play_se("click")

func _on_World_meteor_button_enabled() -> void:
	enable_meteor_power()

func _on_World_meteor_button_disabled() -> void:
	disable_meteor_power()


func _on_MeteorPanel_pressed() -> void:
	emit_signal("meteor_panel_pressed")
	SoundManager.play_se("click")


func _on_World_meteor_panel_disabled() -> void:
	disable_meteor_panel()


func _on_World_meteor_panel_enabled() -> void:
	enable_meteor_panel()


func _on_World_progress_meteor_creation_changed(current_time, duration) -> void:
	$MainPanel/MeteorsPanelContainer/MeteorPanel/TextureProgress.max_value = duration
	$MainPanel/MeteorsPanelContainer/MeteorPanel/TextureProgress.value = current_time
	if current_time == duration:
		$MainPanel/MeteorsPanelContainer/MeteorPanel/TextureProgress.value = 0


func _on_World_meteors_amount_changed(current_meteors) -> void:
	update_meteors_amount(current_meteors)


func _on_World_game_over(current_round) -> void:
	end_round = current_round
	announce_game_over()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "game_over_announcing":
		show_game_over_panel()


func _on_World_game_over_panel_hided() -> void:
	hide_game_over_panel()


func _on_RestartButton_pressed() -> void:
	emit_signal("restart_button_pressed")
	SoundManager.play_se("click")


func _on_ArrowsPanel_pressed() -> void:
	emit_signal("arrow_panel_pressed")
	SoundManager.play_se("click")


func _on_World_arrow_panel_disabled() -> void:
	disable_arrow_panel()


func _on_World_arrow_panel_enabled() -> void:
	enable_arrow_panel()


func _on_World_arrows_amount_changed(current_arrows) -> void:
	update_arrows_amount(current_arrows)


func _on_World_progress_arrow_creation_changed(current_time, duration) -> void:
	$MainPanel/ArrowsPanelContainer/ArrowsPanel/TextureProgress.max_value = duration
	$MainPanel/ArrowsPanelContainer/ArrowsPanel/TextureProgress.value = current_time
	if current_time == duration:
		$MainPanel/ArrowsPanelContainer/ArrowsPanel/TextureProgress.value = 0

func _on_ArrowPowerButton_pressed() -> void:
		emit_signal("arrow_power_pressed")
		SoundManager.play_se("click")


func _on_World_arrow_button_enabled() -> void:
	enable_arrow_power()


func _on_World_arrow_button_disabled() -> void:
	disable_arrow_power()


func _on_UnitsPanel_pressed() -> void:
	emit_signal("unit_panel_pressed")
	SoundManager.play_se("click")


func _on_World_battle_started() -> void:
	$BattleAnnouncer/AnimationPlayer.play("battle_announcing")


func _on_World_GUI_displayed() -> void:
	show_GUI()

func _on_PauseButton_pressed() -> void:
	$PausePanel.visible = true
	get_tree().paused = true
	SoundManager.play_se("click")

func _on_ReturnButton_pressed() -> void:
	$PausePanel.visible = false
	get_tree().paused = false
	SoundManager.play_se("click")



func _on_CloudsController_mouse_entered() -> void:
	emit_signal("cloud_area_entered")


func _on_CloudsController_mouse_exited() -> void:
	emit_signal("cloud_area_exited")

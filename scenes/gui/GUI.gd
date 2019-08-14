extends Control



#Connection to the World Scene
signal unit_panel_pressed #Attemps to create a new unit 
signal cloud_area_clicked(mouse_position) 
signal cloud_area_click_release

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_corn_amount_panel(corn_amount):
	$ResourcesPanel/MarginContainer/CornAmountPanel/CornAmountLabel.text = str(corn_amount)
	
func update_units_amount(current_units):
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

func _on_CloudsController_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		emit_signal("cloud_area_clicked", get_global_mouse_position())
	elif event.is_action_released("mouse_click"):
		emit_signal("cloud_area_click_release")

func _on_World_corn_amount_changed(corn_amount) -> void:
	update_corn_amount_panel(corn_amount)


func _on_UnitsPanel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		emit_signal("unit_panel_pressed")

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


func _on_World_unit_panel_disabled() -> void:
	disable_unit_panel()

func _on_World_unit_panel_enabled() -> void:
	enable_unit_panel()


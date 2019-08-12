extends Control



#Connection to the World Scene
signal unit_panel_pressed #Attemps to create a new unit 
signal cloud_area_clicked(mouse_position) 

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

func _on_CloudsController_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		emit_signal("cloud_area_clicked", get_global_mouse_position())


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

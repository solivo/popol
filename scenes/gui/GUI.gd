extends Control


signal cloud_area_clicked(mouse_position) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_corn_amount_panel(corn_amount):
	$MarginContainer/MainPanel/CornAmountPanel/CornAmountLabel.text = str(corn_amount)


func _on_CloudsController_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		emit_signal("cloud_area_clicked", get_global_mouse_position())


func _on_World_corn_amount_changed(corn_amount) -> void:
	update_corn_amount_panel(corn_amount)

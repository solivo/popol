extends Node2D

#Scenes
var CornPlant = preload("res://scenes/corn_plant/CornPlant.tscn")

var ExpulsionEffect = preload("res://world/ExpulsionEffect.tscn")

#Flags
var plant_1_created = false
var plant_2_created = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not plant_1_created:
		create_new_plant(1)
		plant_1_created = true
		
	if not plant_2_created:
		create_new_plant(2)
		plant_2_created = true

func _on_PlayerArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_click"):
		#Instantiate a expulsion effect
		var expulsion_effect = ExpulsionEffect.instance()
		expulsion_effect.position = get_global_mouse_position()
		add_child(expulsion_effect)
		
func create_new_plant( number_plant_pos ) -> void:
		var corn_plant = CornPlant.instance()
		corn_plant.connect("ready_for_harvest", $Building, "add_task", ["harvest"])
		if number_plant_pos == 1:
			corn_plant.position = $SpawningPlantPosition1.position
		elif number_plant_pos == 2:
			corn_plant.position = $SpawningPlantPosition2.position
		add_child(corn_plant)  
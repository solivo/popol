extends Node2D

#Scenes
var MediumCloud = preload("res://scenes/cloud/medium_cloud/MediumCloud.tscn")
var CornPlant = preload("res://scenes/corn_plant/CornPlant.tscn")

var ExpulsionEffect = preload("res://world/ExpulsionEffect.tscn")

export var corns_harvested := 6 #Corn amount added by each farmer 

#Current Resources
var corn_amount := 0  #Initial corn amount

#Unit creation duration
export var unit_creation_duration := 4
var unit_creation_current_time := 0

#Units
var current_units := 1

#Unit cost
export var unit_cost : = 6

#Flags
var plant_1_created = false
var plant_2_created = false
var creating_unit = false

#Signals
#GUI
signal corn_amount_changed(corn_amount)
signal units_amount_changed(current_units)
signal progress_unit_creation_changed(current_time, duration)

#Building
signal unit_created

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	#Set the initial units to the building
	$Building.units_avaliable = current_units
	
	#Set and start timers
	$CloudSpawnTimer.start()

func _process(delta: float) -> void:
	if not plant_1_created:
		create_new_plant(1)
		plant_1_created = true
		
	if not plant_2_created:
		create_new_plant(2)
		plant_2_created = true


func create_new_plant( number_plant_pos ) -> void:
		var corn_plant = CornPlant.instance()
		corn_plant.connect("ready_for_harvest", $Building, "add_task", ["harvest"])
		corn_plant.connect("plant_collected", self, "create_new_plant")
		if number_plant_pos == 1:
			corn_plant.position = $SpawningPlantPosition1.position
			corn_plant.number_position = 1
		elif number_plant_pos == 2:
			corn_plant.position = $SpawningPlantPosition2.position
			corn_plant.number_position = 2
		add_child(corn_plant)  

func create_new_unit():
	emit_signal("unit_created")
	current_units += 1
	$Building.units_avaliable += 1 #Set units avaliable to made tasks
	corn_amount -= unit_cost
	$UnitCreationTimer.stop() #Reset
	creating_unit = false #Reset
	#GUI
	emit_signal("corn_amount_changed", corn_amount)
	emit_signal("units_amount_changed", current_units)


func _on_Building_corn_stored() -> void:
	corn_amount += corns_harvested
	#Update GUI
	emit_signal("corn_amount_changed", corn_amount)


func _on_CloudSpawnTimer_timeout() -> void:
	var spawn_location : PathFollow2D = $CloudsSpawnPath/SpawnLocation
	spawn_location.set_offset(randi())
	var cloud = MediumCloud.instance()
	cloud.position = spawn_location.position
	cloud.cloud_speed = round(rand_range(1, 6))
	add_child(cloud)


func _on_GUI_cloud_area_clicked(mouse_position) -> void:
	#Instantiate a expulsion effect
	var expulsion_effect = ExpulsionEffect.instance()
	expulsion_effect.position = mouse_position
	add_child(expulsion_effect)


func _on_GUI_unit_panel_pressed() -> void:
	if corn_amount >= unit_cost and not creating_unit:
		creating_unit = true
		unit_creation_current_time = 0 # Reset
		$UnitCreationTimer.start()
		
	
	
func _on_UnitCreationTimer_timeout() -> void:
	unit_creation_current_time += 1
	emit_signal("progress_unit_creation_changed", unit_creation_current_time, unit_creation_duration)
	if unit_creation_current_time >= unit_creation_duration:
		create_new_unit()


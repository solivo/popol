extends Node2D

#Scenes
var MediumCloud = preload("res://scenes/cloud/medium_cloud/MediumCloud.tscn")
var CornPlant = preload("res://scenes/corn_plant/CornPlant.tscn")

var ExpulsionEffect = preload("res://world/ExpulsionEffect.tscn")

export var corns_harvested := 6 #Corn amount added by each farmer 

var corn_amount := 0  #Initial corn amount

#Flags
var plant_1_created = false
var plant_2_created = false

signal corn_amount_changed(corn_amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
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

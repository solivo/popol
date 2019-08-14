extends Node2D

#Scenes
var MediumCloud = preload("res://scenes/cloud/medium_cloud/MediumCloud.tscn")
var CornPlant = preload("res://scenes/corn_plant/CornPlant.tscn")
#Powers
var Meteor = preload("res://scenes/power/meteor/Meteor.tscn")
#Player
var PowerCursor = preload("res://scenes/player/PowerCursor.tscn")

var EnemyWarrior = preload("res://scenes/human/enemy/warrior/WarriorEnemy.tscn")
var ExpulsionEffect = preload("res://scenes/player/expulsion_effect/ExpulsionEffect.tscn")

export var corns_harvested := 6 #Corn amount added by each farmer 

#Round variables
export var current_round : = 1 #Initial round
export var round_duration : = 3 #Rond duration in minutes 
var current_minutes : = round_duration
var current_seconds : = 0

#Current Resources
var corn_amount := 0  #Initial corn amount

#Unit creation duration
export var unit_creation_duration := 4
var unit_creation_current_time := 0

#Units
var current_units := 1

#Powers - Meteors
var meteors := 0
export var meteor_creation_duration := 6
var meteor_creation_current_time := 0
export var meteor_cost := 18

#Enemies
export var total_enemies := 2 # Total enemies peer round
#var current_enemies : int
var enemies_created := 0

#Unit cost
export var unit_cost : = 6

#Flags
var plant_1_created = false
var plant_2_created = false
var plant_3_created = false

var enemies_defeated = false
var creating_unit = false
var creating_meteor = false
var on_battle = false

#Signals
#GUI
signal corn_amount_changed(corn_amount)
signal units_amount_changed(current_units)
signal progress_unit_creation_changed(current_time, duration)
signal round_minutes_changed(current_minutes)
signal round_seconds_changed(current_seconds)
signal round_changed(current_round)
signal unit_panel_disabled
signal unit_panel_enabled
signal meteor_button_enabled
signal meteor_button_disabled
signal meteor_panel_disabled
signal meteor_panel_enabled
signal progress_meteor_creation_changed(current_time, duration)
signal meteors_amount_changed(current_meteors)

#Building
signal unit_created
signal battle_started
signal battle_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	#Set the initial units to the building
	$Building.units_avaliable = current_units
	
	#Set and start timers
	$CloudSpawnTimer.start()
	start_round()

func _process(delta: float) -> void:
	if not plant_1_created:
		create_new_plant(1)
		plant_1_created = true
		
	if not plant_2_created:
		create_new_plant(2)
		plant_2_created = true
	if not plant_3_created:
		create_new_plant(3)
		plant_3_created = true

func create_new_plant(number_plant_pos) -> void:
		var corn_plant = CornPlant.instance()
		corn_plant.connect("ready_for_harvest", $Building, "add_task", ["harvest"])
		corn_plant.connect("plant_collected", self, "create_new_plant")
		if number_plant_pos == 1:
			corn_plant.position = $SpawningPlantPosition1.position
			corn_plant.number_position = 1
		elif number_plant_pos == 2:
			corn_plant.position = $SpawningPlantPosition2.position
			corn_plant.number_position = 2
		elif number_plant_pos == 3:
			corn_plant.position = $SpawningPlantPosition3.position
			corn_plant.number_position = 3
		add_child(corn_plant) 


func start_round():
	#Reset variables
	current_minutes = round_duration
	current_seconds = 0
	#Update GUI
	emit_signal("round_minutes_changed", current_minutes)
	emit_signal("round_seconds_changed", current_seconds)
	emit_signal("round_changed", current_round)
	emit_signal("meteor_button_disabled")
	
	#Start timer
	$RoundTimer.start()

func start_battle():
	$RoundTimer.stop()
	on_battle = true
	emit_signal("battle_started") #Preparing the untis for spawninh warriors
	emit_signal("unit_panel_disabled")
	emit_signal("meteor_button_enabled")
#	current_enemies = total_enemies
	enemies_created = 0
	$EnemySpawningTimer.start()

func create_new_unit():
	emit_signal("unit_created")
	current_units += 1
	$Building.current_units = current_units
	$Building.units_avaliable += 1 #Set units avaliable to made tasks
	$UnitCreationTimer.stop() #Reset
	creating_unit = false #Reset
	#GUI
	emit_signal("units_amount_changed", current_units)

func add_new_meteor():
	meteors += 1
	$MeteorCreationTimer.stop()
	creating_meteor = false
	#GUI
	emit_signal("meteors_amount_changed", meteors)

func create_enemy():
	if enemies_created < total_enemies:
		enemies_created += 1
		var enemy = EnemyWarrior.instance()
		enemy.connect("unit_killed", self, "units_changed")
		enemy.position = $EnemySpawningPosition.position
		add_child(enemy)

func units_changed(unit_type):
	if unit_type == "enemy":
		total_enemies -= 1
		if total_enemies <= 0:
			print("Roud Win!!!")
			end_round()
	if unit_type == "ally":
		current_units -= 1
		$Building.current_units = current_units
		#Update GUI
		emit_signal("units_amount_changed", current_units)
		if current_units == 0:
			print("Game Over!!!!")

func end_round():
	current_round += 1
	on_battle = false
	emit_signal("battle_over")
	$EnemySpawningTimer.stop()
#	emit_signal("unit_panel_enabled")
	increase_dificulty()
	start_round()

func increase_dificulty():
	total_enemies += 5 #Increase the enemy numbers

func execute_power(cursor_position):
	#Instance a meteor on the cursor position
	var meteor = Meteor.instance()
	meteor.position = cursor_position
	meteor.position.y = 0
	add_child(meteor)

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
	$SpawningExpulsionTimer.start()


func _on_GUI_unit_panel_pressed() -> void:
	if corn_amount >= unit_cost and not creating_unit:
		creating_unit = true
		unit_creation_current_time = 0 # Reset
		corn_amount -= unit_cost
		emit_signal("corn_amount_changed", corn_amount)
		emit_signal("unit_panel_disabled")
		$UnitCreationTimer.start()


func _on_UnitCreationTimer_timeout() -> void:
	unit_creation_current_time += 1
	emit_signal("progress_unit_creation_changed", unit_creation_current_time, unit_creation_duration)
	if unit_creation_current_time >= unit_creation_duration:
		create_new_unit()
#		if not on_battle:
#			emit_signal("unit_panel_enabled")


func _on_RoundTimer_timeout() -> void:
	if current_seconds  <= 0:
		current_seconds = 45
		if current_minutes > 0:
			current_minutes -= 1
			emit_signal("round_minutes_changed", current_minutes)
	elif current_seconds > 0:
		current_seconds -= 1
	#Update GUI
	emit_signal("round_seconds_changed", current_seconds)
	#Check if the round time is end
	if current_seconds == 0 and current_minutes == 0:
		print("Battle Started!")
		start_battle()


func _on_EnemySpawningTimer_timeout() -> void:
	create_enemy()
	

func _on_Building_units_changed(unit_type) -> void:
	units_changed(unit_type)


func _on_BattleField_body_exited(body: PhysicsBody2D) -> void:
	#Keep the units on the battlefield
	if body is Warrior:
		if body.current_side == "right":
			body.current_side = "left"
		else:
			body.current_side = "right"



func _on_SpawningExpulsionTimer_timeout() -> void:
	#Instantiate a expulsion effect
	var expulsion_effect = ExpulsionEffect.instance()
	expulsion_effect.position = get_global_mouse_position()
	add_child(expulsion_effect)


func _on_GUI_cloud_area_click_release() -> void:
	$SpawningExpulsionTimer.stop()


func _on_GUI_meteor_power_clicked() -> void:
	if meteors > 0 and on_battle:
		meteors -= 1
		#Create a new power cursor
		var power_cursor = PowerCursor.instance()
		connect("battle_over", power_cursor, "quit_power_cursor") #Quit the power cursor if the battle is over
		power_cursor.connect("power_executed", self, "execute_power") 
		add_child(power_cursor)


func _on_GUI_meteor_panel_pressed() -> void:
	if corn_amount >= meteor_cost and not creating_meteor:
		creating_meteor = true
		meteor_creation_current_time = 0 # Reset
		corn_amount -= meteor_cost
		emit_signal("corn_amount_changed", corn_amount)
		emit_signal("meteor_panel_disabled")
		$MeteorCreationTimer.start()

func _on_MeteorCreationTimer_timeout() -> void:
	meteor_creation_current_time += 1
	emit_signal("progress_meteor_creation_changed", meteor_creation_current_time, meteor_creation_duration)
	if meteor_creation_current_time >= meteor_creation_duration:
		add_new_meteor()
#		if not on_battle:
#			emit_signal("meteor_panel_enabled")


func _on_World_corn_amount_changed(corn_amount) -> void:
	if corn_amount >= unit_cost and not on_battle and not creating_unit:
		emit_signal("unit_panel_enabled")

	if corn_amount >= meteor_cost and not on_battle and not creating_meteor:
		emit_signal("meteor_panel_enabled")
	
	if corn_amount < unit_cost and not on_battle and not creating_unit:
		emit_signal("unit_panel_disabled")
	
	if corn_amount < meteor_cost and not on_battle and not creating_meteor:
		emit_signal("meteor_panel_disabled")

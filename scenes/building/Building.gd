extends StaticBody2D

#Human Units scenes
var Gatherer = preload("res://scenes/human/gatherer/Gatherer.tscn")
var Warrior = preload("res://scenes/human/warrior/Warrior.tscn")

signal gatherer_created(gatherer)
signal corn_stored
signal units_changed(unit_type)
signal gatherer_exited #Quit units when there are a battle 
signal warrior_exited #Quit warrior units when a battle is over

#Units on the building
export var units_avaliable : int = 1
export var current_units : int = 1

#flags
var unit_created = false
var unit_queue = []
var task_queue = [] #Store each harvest signal
var on_battle = false


func _ready() -> void:
	units_avaliable = current_units

func _process(delta: float) -> void:
	if units_avaliable > 0:
		var task_name
		if not  on_battle:
			if task_queue.size() > 0:
				task_name = task_queue.pop_back()
		else:
			task_name = "battle"
		process_task(task_name)

func add_task(task_name):
	task_queue.append(task_name)


func process_task(task_name):
	if task_name == "harvest":
		send_gatherer()
	elif task_name == "battle":
		send_warrior()

func send_gatherer():
	if units_avaliable > 0:
		unit_queue.append("gatherer")
		units_avaliable -= 1

func send_warrior():
	if units_avaliable > 0:
		unit_queue.append("warrior")
		units_avaliable -=1

func spawn_unit(unit_name):
	if unit_name == "gatherer":
		var gatherer = Gatherer.instance()
		gatherer.position = $SpawningPoint.position
		gatherer.connect("plant_not_collected", self, "restore_harvest_task")
		connect("gatherer_exited", gatherer, "quit_gatherer")
		add_child(gatherer)
		emit_signal("gatherer_created", gatherer)

	elif unit_name == "warrior":
		var warrior = Warrior.instance()
		warrior.position = $SpawningPoint.position
		warrior.connect("unit_killed", self, "unit_killed")
		connect("warrior_exited", warrior, "quit_warrior")
		add_child(warrior)

func unit_killed(unit_type):
	emit_signal("units_changed", unit_type) #Redirect signal to the world

func restore_harvest_task():
	task_queue.append("harvest")

func _on_BuildingDoorArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("farmer"):
		if body.plant_collected and not on_battle:
			emit_signal("corn_stored")
			body.enter_to_building() # Play an animation before quit
			units_avaliable += 1 #A farmer is avaliable for the comming tasks


func _on_UnitSpawningTimer_timeout() -> void:
	if unit_queue.size() > 0:
		var unit_name = unit_queue.pop_back()
		spawn_unit(unit_name) 


func _on_World_unit_created() -> void:
	#Create a new unit
	if not on_battle:
		units_avaliable += 1

func _on_World_battle_started() -> void:
	on_battle = true
	emit_signal("gatherer_exited")
	unit_queue = [] #Reset unit_queue for the next spawnings
	units_avaliable = current_units


func _on_World_battle_over() -> void:
	emit_signal("warrior_exited")
	on_battle = false
	unit_queue = []
	units_avaliable = current_units

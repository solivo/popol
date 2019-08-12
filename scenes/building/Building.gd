extends StaticBody2D

#Human Units scenes
var Gatherer = preload("res://scenes/human/gatherer/Gatherer.tscn")

signal gatherer_created(gatherer)
signal corn_stored

#Units on the building
export var units_avaliable : int = 1
export var current_units : int = 1
#flags
var unit_created = false
var unit_queue = []
var task_queue = [] #Store each harvest signal


func _process(delta: float) -> void:
	if task_queue.size() > 0 and units_avaliable:
		var task_name = task_queue.pop_back()
		process_task(task_name)


func add_task(task_name):
	task_queue.append(task_name)


func process_task(task_name):
	if task_name == "harvest":
		send_gatherer()

func send_gatherer():
	if units_avaliable > 0:
		unit_queue.append("gatherer")
		units_avaliable -= 1


func spawn_unit(unit_name):
	if unit_name == "gatherer":
		var gatherer = Gatherer.instance()
		gatherer.position = $SpawningPoint.position
		add_child(gatherer)
		emit_signal("gatherer_created", gatherer)


func _on_BuildingDoorArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("farmer"):
		if body.plant_collected:
			emit_signal("corn_stored")
			body.enter_to_building() # Play an animation before quit
			units_avaliable += 1 #A farmer is avaliable for the comming tasks


func _on_UnitSpawningTimer_timeout() -> void:
	if unit_queue.size() > 0:
		var unit_name = unit_queue.pop_back()
		spawn_unit(unit_name) 
		print(unit_queue)


func _on_World_unit_created() -> void:
	#Create a new unit
	units_avaliable += 1
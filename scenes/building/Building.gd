extends StaticBody2D

#Human Units scenes
var Farmer = preload("res://scenes/human/farmer/Farmer.tscn")

signal farmer_created(farmer)
signal corn_stored

#Units on the building
export var farmers_avaliable : int = 2
#flags
var unit_created = false
var unit_queue = []
var task_queue = [] #Store each harvest signal

func _process(delta: float) -> void:
	if task_queue.size() > 0 and farmers_avaliable:
		var task_name = task_queue.pop_back()
		process_task(task_name)


func add_task(task_name):
	task_queue.append(task_name)


func process_task(task_name):
	if task_name == "harvest":
		send_farmer()

func send_farmer():
	if farmers_avaliable > 0:
		unit_queue.append("farmer")
		farmers_avaliable -= 1


func spawn_unit(unit_name):
	if unit_name == "farmer":
		var farmer = Farmer.instance()
		farmer.position = $SpawningPoint.position
		add_child(farmer)
		emit_signal("farmer_created", farmer)


func _on_FarmerSpawningTimer_timeout() -> void:
	if unit_queue.size() > 0:
		var unit_name = unit_queue.pop_back()
		spawn_unit(unit_name) 
		print(unit_queue)


func _on_BuildingDoorArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("farmer"):
		if body.plant_collected:
			emit_signal("corn_stored")
			body.queue_free() # Play an animation before quit
			farmers_avaliable += 1 #A farmer is avaliable for the comming tasks

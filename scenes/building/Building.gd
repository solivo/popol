extends StaticBody2D

#Human Units scenes
var Farmer = preload("res://scenes/human/farmer/Farmer.tscn")

signal farmer_created(farmer)
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

func _on_SpawningTimer_timeout() -> void:
	if unit_queue.size() > 0:
		var unit_name = unit_queue.pop_back()
		spawn_unit(unit_name) 
		print(unit_queue)

func spawn_unit(unit_name):
	if unit_name == "farmer":
		var farmer = Farmer.instance()
		farmer.position = $SpawningPoint.position
		add_child(farmer)
		emit_signal("farmer_created", farmer)

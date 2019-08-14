extends KinematicBody2D

export var unit_speed := 40 

var current_action := "harvesting" 

var plant_collected = false

#signal plant_collected(number_position)
signal plant_not_collected #Trigger the signal when the farmer disappear before collect the plant
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	go_to_harvest()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Handle unit movement
	if current_action == "harvesting":
		move_and_slide(Vector2(1,0) * unit_speed)
	elif current_action == "collecting_plant":
		move_and_slide(Vector2(-1,0) * unit_speed)

func go_to_harvest():
	$AnimationPlayer.play("gatherer_walking")
	current_action = "harvesting" 

func collect_plant():
	plant_collected = true
	current_action = "collecting_plant"
	$PlantDectectionArea.monitoring = false
	$AnimationPlayer.play("gatherer_harvesting")

func enter_to_building():
	$AnimationPlayer.play("gatherer_returning")

func quit_gatherer():
	if not plant_collected:
		emit_signal("plant_not_collected")
		$AnimationPlayer.play("gatherer_leaving")
	else:
		print("QUITANDO RECOLECTORRR")
		$AnimationPlayer.play("gatherer_returning")

func _on_PlantDectectionArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("corn_plant"):
		if body.mature_plant:
			collect_plant()
			body.queue_free() #Quit the plant

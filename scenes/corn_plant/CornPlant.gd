extends StaticBody2D

var water_amount := 0 
var number_position := 0

signal ready_for_harvest
signal plant_collected(number_position)

#Flags
var mature_plant = false

func _ready() -> void:
	water_amount = 0
	#Set the initial state of the plant and water indicator
	$AnimatedSpritePlant.play("growing_plant")
	$AnimatedSpriteIndicator.play("indicator_off")


func add_water():
	self.water_amount += 1
	SoundManager.play_se("water", true , false)

func consume_water():
	if $AnimatedSpritePlant.animation == "growing_plant" and $AnimatedSpritePlant.is_playing():
		$AnimatedSpritePlant.frame += 1
	water_amount -= 1
	$AnimatedSpriteIndicator.play("indicator_off")


func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSpritePlant.animation == "growing_plant":
		if $AnimatedSpritePlant.frame == 16:
			ready_to_harvest()

func ready_to_harvest():
	emit_signal("ready_for_harvest")
	$AnimatedSpritePlant.play("mature_plant")
	mature_plant = true


func _on_GrowTimer_timeout() -> void:
	if water_amount > 1:
		consume_water()
		$AnimatedSpriteIndicator.play("indicator_on")
	else:
		$AnimatedSpriteIndicator.play("indicator_off")


func _on_CornPlant_tree_exited() -> void:
	emit_signal("plant_collected", number_position)

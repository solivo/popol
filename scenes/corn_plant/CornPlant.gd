extends StaticBody2D

var water_amount := 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	water_amount = 0
	#Set the initial state of the plant and water indicator
	$AnimatedSpritePlant.play("growing_plant")
	$AnimatedSpriteIndicator.play("indicator_off")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func add_water():
	self.water_amount += 1
	print("water added!")

func consume_water():
	if $AnimatedSpritePlant.animation == "growing_plant" and $AnimatedSpritePlant.is_playing():
		$AnimatedSpritePlant.frame += 1
	water_amount -= 1
	print($AnimatedSpritePlant.frame)
	$AnimatedSpriteIndicator.play("indicator_off")


func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSpritePlant.animation == "growing_plant":
		if $AnimatedSpritePlant.frame == 16:
			ready_to_harvest()

func ready_to_harvest():
	print("ready to harvest!")
	$AnimatedSpritePlant.play("mature_plant")



func _on_GrowTimer_timeout() -> void:
	if water_amount > 1:
		consume_water()
		$AnimatedSpriteIndicator.play("indicator_on")
	else:
		$AnimatedSpriteIndicator.play("indicator_off")

extends Node2D

var aiming := false
var initial_rotation_state = rotation
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if aiming:
		look_at(get_global_mouse_position())
	pass

func preparing_arrow():
	aiming = true
	$AnimationPlayer.play("character_aiming")

func keep_waiting():
	aiming = false
	rotation = initial_rotation_state
	$AnimationPlayer.play("character_idle")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "character_entering":
		$AnimationPlayer.play("character_idle")


func _on_World_battle_started() -> void:
	$AnimationPlayer.play("character_entering")


func _on_World_battle_over() -> void:
	$AnimationPlayer.play("character_leaving")

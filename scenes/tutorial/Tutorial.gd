extends Node

var last_animation = ""
var cloud_tutorial_displayed = false
var unit_tutorial_displayed = false
var battle_tutorial_displayed = false

func play():
	if not cloud_tutorial_displayed:
		$AnimationPlayer.play("clouds_tutorial_displaying")
		cloud_tutorial_displayed = true
	elif not unit_tutorial_displayed:
		$AnimationPlayer.play("units_tutorial_displaying")
		unit_tutorial_displayed = true
	elif not battle_tutorial_displayed:
		$AnimationPlayer.play("battle_tutorial_displaying")
		battle_tutorial_displayed = true

func reset():
	cloud_tutorial_displayed = false
	unit_tutorial_displayed = false
	battle_tutorial_displayed = false
extends KinematicBody2D

class_name Warrior 

export var unit_speed := 120 

var current_action := "searching_enemies"  #Default action
var current_side = "right"

#Determines the probability of winning the next fight
var winning_factor = [true,false]

var unit_target = "enemy" #Set enemy or warrior
var unit_type = "ally" #Ally or Enemy
var default_side = "right"

#Flags
var attacking = false
var leaving = false
var enemies_on_right = true
var enemies_on_left = false

signal unit_killed

signal attack_executed(side) #Emit a signal to the near enemy
signal fight_result(result) #Give a result form the atacck (win or defeat)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	current_side = default_side
	search_enemies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Handle unit movement
	if current_action == "searching_enemies" and not leaving:
		if $RayCastRight.is_colliding():
			var enemy = $RayCastRight.get_collider()
			if enemy.is_in_group(unit_target):
				if not enemy.attacking:
					current_side = "right"
		elif $RayCastLeft.is_colliding():
			var enemy = $RayCastLeft.get_collider()
			if enemy.is_in_group(unit_target):
				if not enemy.attacking:
					current_side = "left"
		search_enemies()

func search_enemies():
	if $RayCastLeft.enabled and $RayCastRight.enabled:
		if current_side == "right":
			$AnimationPlayer.play("warrior_walking_right")
			move_and_slide(Vector2(1,0) * unit_speed)
		else:
			$AnimationPlayer.play("warrior_walking_left")
			move_and_slide(Vector2(-1,0) * unit_speed)

func _on_AttackArea_body_entered(body: PhysicsBody2D) -> void:
	#Attack the nearest enemy
	if body.is_in_group(unit_target): #Change for enemy
		var enemy = body
		if not enemy.attacking and not attacking:
			print("attacking!")
			attacking = true
			enemy.attacking = true
			current_action = "attacking"
			enemy.current_action = "attacking"
			$CollisionShapeWarrior.disabled = true
			enemy.get_node("CollisionShapeWarrior").disabled = true
			enemy.receive_attack(current_side)
			connect("fight_result", enemy, "end_attack")
			attack_enemy()


func attack_enemy():
	$CollisionShapeWarrior.disabled = true
	$RayCastLeft.enabled = false
	$RayCastRight.enabled = false
	if current_side == "right":
		$AnimationPlayer.play("warrior_attacking_right_1")
	else:
		$AnimationPlayer.play("warrior_attacking_left_1")
	$FightTimer.start()

#Determine the duration of the fight
func _on_FightTimer_timeout() -> void:
	var fight_result = winning_factor[rand_range(0, winning_factor.size())]
	end_attack(fight_result)
	fight_result = !fight_result
	emit_signal("fight_result", fight_result)

func end_attack(win):
	print(win) 
	if  win:
		winning_factor.append("false") #Decreases the probabity of win the next fight
		attacking = false
		current_action = "searching_enemies"
		current_side = default_side
		$CollisionShapeWarrior.disabled = false
		$RayCastLeft.enabled = true
		$RayCastRight.enabled = true
	else:
		kill_warrior()

func receive_attack(side):
	$CollisionShapeWarrior.disabled = true
	$RayCastLeft.enabled = false
	$RayCastRight.enabled = false
	if side == "right":
		$AnimationPlayer.play("warrior_attacking_left_1")
	else:
		$AnimationPlayer.play("warrior_attacking_right_1")


func kill_warrior():
	emit_signal("unit_killed", unit_type)
	leaving = true
	if current_side == "right":
		$AnimationPlayer.play("warrior_dying_right")
	else:
		$AnimationPlayer.play("warrior_dying_left")

func quit_warrior():
	leaving = true
	if current_side == "right":
		$AnimationPlayer.play("warrior_leaving_right")
	else:
		$AnimationPlayer.play("warrior_leaving_left")

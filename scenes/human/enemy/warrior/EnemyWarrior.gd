extends Warrior

func _ready() -> void:
	unit_type = "enemy"
	default_side = "left"
	current_side = default_side
	unit_target = "warrior"
	winning_factor = [false, true]
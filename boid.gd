extends Node2D

@export var BODY : Area2D
@export var SIGHT : Area2D
@export var PERSONAL_SPACE : Area2D

@export_group("PARAMETERS")
@export var max_speed : int = 2


var velocity = Vector2(1,2)

func _physics_process(_delta)->void:
	var avoidanceVector = Vector2.ZERO
	var invaders: Array[Area2D] = PERSONAL_SPACE.get_overlapping_areas().filter(func(area): return BODY != area)
	
	for invader in invaders:
		avoidanceVector.x += global_position - invader.shape_owner_get_transform()
	
	print(SIGHT.get_overlapping_areas().filter(func(area): return BODY != area))
	self.translate(velocity.normalized()*max_speed)

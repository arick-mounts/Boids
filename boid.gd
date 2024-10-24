class_name Boid
extends Node2D

@export var BODY : Area2D
@export var SIGHT : Area2D
@export var PERSONAL_SPACE : Area2D

@export_group("PARAMETERS")
@export var avoid_proportion: float = 2
@export var avoid_factor:float = .25
@export var matching_factor:float = .005
@export var centering_factor:float = .0025
@export var turn_factor = .1
@export var min_speed = 2
@export var max_speed = 4

var velocity :Vector2

	
var x_min = 100
var x_max = 1052
var y_min = 100
var y_max = 548

func _ready():
	velocity = Vector2(randf_range(min_speed, max_speed), randf_range(min_speed, max_speed))
	
func _physics_process(_delta)->void:
	var avoidanceVector = Vector2.ZERO
	var averageVelocity = Vector2.ZERO
	var averagePosition = Vector2.ZERO
	var invaders: Array[Area2D] = PERSONAL_SPACE.get_overlapping_areas().filter(func(area): return BODY != area)
	var neighbors: Array[Area2D] = SIGHT.get_overlapping_areas().filter(func(area): return BODY != area && !invaders.any(func (invader): return invader == area))

	for invader in invaders:
		avoidanceVector += (Vector2(avoid_proportion,avoid_proportion) / (global_position - invader.global_position)).clampf(-12,12)
	
	var neighboring_boids = 0
	for neighbor in neighbors:
		var parent = neighbor.get_parent()
		if(parent is Boid):
			var boid:Boid = parent
			averageVelocity += boid.velocity
			averagePosition += boid.global_position
			neighboring_boids +=1
	if(neighboring_boids >0):
		averageVelocity = averageVelocity/neighboring_boids
		averagePosition = averagePosition/neighboring_boids
	velocity += (averageVelocity - velocity) * matching_factor
	velocity += (averagePosition - global_position) * centering_factor
	
	velocity += avoidanceVector*avoid_factor
	
	if(global_position.x < x_min):
		velocity.x += turn_factor
	if(global_position.x > x_max):
		velocity.x -= turn_factor
	if(global_position.y < y_min):
		velocity.y += turn_factor
	if(global_position.y > y_max):
		velocity.y -= turn_factor
	
	var speed = velocity.length()
	if(speed < min_speed):
		velocity = (velocity/speed)*min_speed
	if (speed>max_speed):
		velocity = (velocity/speed) * max_speed
	
	self.rotation =velocity.angle()
	self.translate(velocity)

extends Node2D

@export_group("PARAMETERS")
@export var avoid_proportion: float = 2
@export var avoid_factor:float = 5
@export var matching_factor:float = .05
@export var centering_factor:float = .0005
@export var turn_factor = .1
@export var min_speed = 1
@export var max_speed = 17

var numBoids = 40
var boids: Array[boid_boi]

var personal_space = 30
var sight = 100

var personal_space_sqrd = personal_space ^ 2
var sight_sqrd = sight ^2

@onready var camera_2d: Camera2D = %Camera2D

var screensize :Rect2 
var x_min 
var x_max 
var y_min 
var y_max 

func _ready() -> void:
	
	screensize = get_viewport().get_visible_rect()
	print(screensize)
	x_min = screensize.position.x
	x_max = screensize.position.x + screensize.size.x
	y_min = screensize.position.y
	y_max = screensize.position.y + screensize.size.y
	for i in numBoids:
		var boid = boid_boi.new()
		boid.global_position = Vector2(randi_range(x_min,x_max),randi_range(y_min,y_max))
		boid.velocity = Vector2.from_angle(randf_range(0,TAU)).normalized() * randf_range(min_speed, 2) 
		boids.push_front(boid)
		add_child(boid)
	
func _physics_process(_delta)->void:
	for boid in boids:
		var velocity = boid.velocity
		var avoidanceVector = Vector2.ZERO
		var averageVelocity = Vector2.ZERO
		var averagePosition = Vector2.ZERO
		var neighboring_boids = 0
		
		for other_boid in boids:
			if other_boid == boid:
				break
			elif(boid.global_position.distance_to(other_boid.global_position) < personal_space ):
				avoidanceVector += (boid.global_position - other_boid.global_position)
			elif(boid.global_position.distance_to(other_boid.global_position) < sight):
				averageVelocity += other_boid.velocity
				averagePosition += other_boid.global_position
				neighboring_boids +=1
				
		if(neighboring_boids >0):
			averageVelocity = averageVelocity/neighboring_boids
			averagePosition = averagePosition/neighboring_boids
			#if(averagePosition != Vector2.ZERO):
			velocity += (averagePosition - boid.global_position) * centering_factor
			velocity += (averageVelocity - velocity) * matching_factor
			
		var speed = velocity.length()
		velocity += Vector2( clamp(avoid_factor/avoidanceVector.x,-speed,speed) if avoidanceVector.x != 0 else avoidanceVector.x, clamp(avoid_factor/avoidanceVector.y,-speed,speed) if avoidanceVector.y != 0 else avoidanceVector.y)
		
		
		if(boid.global_position.x < x_min):
			velocity.x += turn_factor
		if(boid.global_position.x > x_max):
			velocity.x -= turn_factor
		if(boid.global_position.y < y_min):
			velocity.y += turn_factor
		if(boid.global_position.y > y_max):
			velocity.y -= turn_factor
		if(speed < min_speed):
			velocity = (velocity/speed) * min_speed
		if (speed>max_speed):
			velocity = (velocity/speed) * max_speed
		boid.velocity = velocity

	
	

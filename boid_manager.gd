extends Node2D

@export_group("PARAMETERS")
@export var avoid_factor:Range
@export var matching_factor:Range
@export var centering_factor:Range 
@export var turn_factor = .2
@export var avoid_speed = 2
@export var min_speed :Range
@export var max_speed :Range

var numBoids = 80
var boids: Array[boid_boi]

var personal_space = 20
var sight = 35

var personal_space_sqrd = personal_space ^ 2
var sight_sqrd = sight ^2

@onready var camera_2d: Camera2D = %Camera2D

var screensize :Rect2 
var x_min 
var x_max 
var y_min 
var y_max 

func _ready() -> void:
	avoid_factor.value =0.05
	matching_factor.value =0.05
	centering_factor.value =0.0005
	min_speed.value = 3
	max_speed.value = 5
	screensize = get_viewport().get_visible_rect()
	print(screensize)
	x_min = screensize.position.x
	x_max = screensize.position.x + screensize.size.x
	y_min = screensize.position.y
	y_max = screensize.position.y + screensize.size.y
	for i in numBoids:
		var boid = boid_boi.new()
		boid.global_position = Vector2(randi_range(x_min,x_max),randi_range(y_min,y_max))
		boid.velocity = Vector2.from_angle(randf_range(0,TAU)).normalized() * randf_range(min_speed.value, max_speed.value)
		boids.push_back(boid)
		add_child(boid)
	
func _physics_process(_delta)->void:
	var first = true
	for boid in boids:
		var velocity = boid.velocity
		var avoidanceVector = Vector2.ZERO
		var averageVelocity = Vector2.ZERO
		var averagePosition = Vector2.ZERO
		var neighboring_boids = 0
		for other_boid in boids:
			if other_boid == boid:
				continue
			elif(boid.global_position.distance_to(other_boid.global_position) < personal_space ):
				var difference = (boid.global_position - other_boid.global_position)
				avoidanceVector += difference 
			elif(boid.global_position.distance_to(other_boid.global_position) < sight):
				averageVelocity += other_boid.velocity
				averagePosition += other_boid.global_position
				neighboring_boids +=1
				
		if(neighboring_boids >0):
			averageVelocity = averageVelocity/neighboring_boids
			averagePosition = averagePosition/neighboring_boids
			velocity += (averagePosition - boid.global_position) * centering_factor.value
			velocity += (averageVelocity - velocity) * matching_factor.value
			
		velocity +=  avoidanceVector * avoid_factor.value
		
		first=false
		if(boid.global_position.x < x_min):
			velocity.x += turn_factor
		if(boid.global_position.x > x_max):
			velocity.x -= turn_factor
		if(boid.global_position.y < y_min):
			velocity.y += turn_factor
		if(boid.global_position.y > y_max):
			velocity.y -= turn_factor
			
		var speed = velocity.length()
		if(speed == 0):
			if(max_speed.value != 0):
				velocity = Vector2.from_angle(randf_range(0,TAU)).normalized() * randf_range(min_speed.value, max_speed.value)
		else:
			if (speed>max_speed.value):
					velocity = ((velocity/speed) * max_speed.value) 
			elif(speed < min_speed.value):
				velocity = (velocity/speed) * min_speed.value 
		boid.velocity = velocity

	
	

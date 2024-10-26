class_name boid_boi
extends Node2D

var velocity = Vector2.ZERO
var first : bool

func _ready() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Boid.png")
	if(first):
		sprite.scale = Vector2(2,2)
	sprite.rotation_degrees= 90
	add_child(sprite)

func _physics_process(delta: float) -> void:
	self.rotation = velocity.angle()
	self.translate(velocity)

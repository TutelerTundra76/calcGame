extends RigidBody2D

func _ready() -> void:
	var force:=Vector2(cos(rotation),sin(rotation))*1000
	linear_velocity=force

extends RigidBody2D

func fire() -> void:
	var force:=Vector2(cos(rotation),sin(rotation))*1000
	linear_velocity=force

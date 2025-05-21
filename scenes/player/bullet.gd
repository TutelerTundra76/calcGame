extends RigidBody2D


func fire(owner, hand = owner) -> void:
	global_position = hand.global_position
	var force:=Vector2(cos(rotation),sin(rotation))*1000
	linear_velocity=force
	#apply_impulse(owner.linear_velocity) # makes it difficult

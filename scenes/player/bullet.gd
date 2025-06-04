extends RigidBody2D


func fire(owner, hand = owner) -> void:
	print("running")
	global_position = hand.global_position
	var force:=Vector2(cos(rotation),sin(rotation))*1000
	linear_velocity=force
	#apply_impulse(owner.linear_velocity) # makes it difficult
func _physics_process(delta: float) -> void:
	if linear_velocity.length()<20:
		queue_free()







func _on_body_entered(body: Node) -> void:
	print("hit")
	Global.points+=200
	await get_tree().create_timer(.1).timeout
	if body is enemy:
		body.queue_free()
	queue_free()

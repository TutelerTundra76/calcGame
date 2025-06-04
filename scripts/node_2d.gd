class_name enemy
extends RigidBody2D
@export var acc:=.85
@export var dec:=.1
@export var maxSpeed:=100.0
@export var sprite:AnimatedSprite2D
@export var damageArea:Area2D
var direction=0
func _physics_process(delta: float) -> void:
	if %NavigationAgent2D.get_path():
		var dir:Vector2= to_local(%NavigationAgent2D.get_next_path_position()).normalized()

		
		if dir.length()==0:
			linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc)
		else:
			linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc)
			
		checkAnimations(dir)
		%NavigationAgent2D.set_velocity_forced(linear_velocity)

func _on_timer_timeout() -> void:
	if Global.player:
		%NavigationAgent2D.target_position=Global.player.global_position
		


func checkAnimations(dir):
	if dir.x>0 and direction==1:
		direction=-1
		sprite.flip_h=true
	elif dir.x<0 and direction==-1:
		direction=1
		sprite.flip_h=false
		
	
	if linear_velocity.length()>20 and sprite.animation!="run":
		sprite.play("run")
	elif linear_velocity.length()<=20 and sprite.animation!="idle":
		sprite.play("idle")


func _on_area_2d_body_entered(body: Node2D) -> void:
	for i in damageArea.get_overlapping_bodies():
		if i is Player:
			%damage_timer.start(1)
			while !%damage_timer.paused:
				i.hit(2)
				await %damage_timer.timeout
				


func _on_area_2d_body_exited(body: Node2D) -> void:
	%damage_timer.paused=true


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.

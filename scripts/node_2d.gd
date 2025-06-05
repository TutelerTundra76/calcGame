class_name enemy
extends RigidBody2D
@export var acc:=.95
@export var dec:=.3
@export var maxSpeed:=230.0
@export var sprite:AnimatedSprite2D
@export var damageArea:Area2D
@export var nav:NavigationAgent2D
var direction=0
func _physics_process(delta: float) -> void:
	if nav:
		if nav.get_path():
			var dir:Vector2= to_local(nav.get_next_path_position()).normalized()

			
			if dir.length()==0:
				linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc* delta)
			else:
				linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc*delta)
				
			checkAnimations(dir)
			nav.set_velocity_forced(linear_velocity)

func _on_timer_timeout() -> void:
	var dist = global_position.distance_to(Global.player.global_position)
	$NavigationAgent2D/Timer.wait_time = min(1, dist / 1000)
	if Global.player:
		nav.target_position=Global.player.global_position
		


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


func _on_area_2d_body_entered(_body: Node2D) -> void:
	for i in damageArea.get_overlapping_bodies():
		if i is Player:
			%damage_timer.start(1)
			while !%damage_timer.paused:
				i.hit(2)
				await %damage_timer.timeout
				


func _on_area_2d_body_exited(_body: Node2D) -> void:
	%damage_timer.stop()

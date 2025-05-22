class_name enemy
extends RigidBody2D
@export var acc:=.85
@export var dec:=.1
@export var maxSpeed:=100.0
@export var sprite:AnimatedSprite2D

var direction=0
func _physics_process(delta: float) -> void:
	var dir:Vector2= (%NavigationAgent2D.target_position-global_position)
	dir=dir.normalized()
	
	if dir.length()==0:
		linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc)
	else:
		linear_velocity=lerp(linear_velocity,dir*maxSpeed,acc)
		
	checkAnimations(dir)
func _on_timer_timeout() -> void:
	if Global.player:
		%NavigationAgent2D.target_position=Global.player.global_position


func checkAnimations(dir):
	if dir.x<0 and direction==1:
		direction=-1
		sprite.flip_h=true
	elif dir.x>0 and direction==-1:
		direction=1
		sprite.flip_h=false
		
	if linear_velocity.length()>20 and sprite.animation!="run":
		sprite.play("run")
	elif linear_velocity.length()<=20 and sprite.animation!="idle":
		sprite.play("idle")

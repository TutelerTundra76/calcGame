class_name Player
extends RigidBody2D
@export_category("movement")
@export var speed:=100
@export var deceleration:=.65
@export var acceleration:=1.0
@export var maxSpeed:=190.0
@export var sprite:AnimatedSprite2D
var direction:=1

@export_category("wepon")
@export var ammoDisplay:Label
@export var arm:Node2D
@export var hand:Node2D
@onready var shootAnim := $armPivot/hand/shootAnimation
@onready var reload := $armPivot/hand/reload
@export var arrows:=20
var bullet :=preload("res://scenes/player/bullet.tscn")
var canShoot := true ## stops you from shooting a zillion arrows at once


@export_category('health')
@export var healthBar:ProgressBar
@export var maxHealth:=10
var health:=0


func _ready() -> void:
	health=maxHealth
	Global.player=self
	Global.connectRewards()
	healthBar.setHealthColor()


func add_ammo():
	arrows+=5
	ammoDisplay.text="Arrows: %s - press 'e' to get more"%arrows


func _physics_process(_delta: float) -> void:
	var dir:=Input.get_vector("left","right","forward","back").normalized()
	checkAnimations(dir)
	linear_velocity=lerp(linear_velocity,dir*maxSpeed,acceleration)
	
	arm.look_at(get_global_mouse_position())
	
	if dir==Vector2.ZERO:
		linear_velocity=lerp(linear_velocity,Vector2.ZERO,deceleration)


func _input(event: InputEvent) -> void:
	ammoDisplay.text="Arrows: %s - press 'e' to get more"%arrows
	if event.is_action_pressed("shoot") and canShoot and arrows>0:
		arrows-=1
		shootAnim.stop()
		shootAnim.play("shoot")
		reload.start()
		canShoot = false
		var bull:RigidBody2D= bullet.instantiate()
		
		
		await reload.timeout #instead of waiting for the timer it just uses time
		bull.global_transform = hand.global_transform
		canShoot = true
		get_tree().root.add_child(bull)
		bull.fire( hand)


func checkAnimations(dir:Vector2):
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


func hit(damage:int):
	health-=damage
	healthBar.value=100*(float(health)/float(maxHealth))
	healthBar.setHealthColor()
	
	#process death
	if health <= 0:
		Global.gameOver.game_over()


func dead() -> void:
	hide()
	canShoot = false
	$hitbox.set_deferred("disabled", true) # you stop colliding
	maxSpeed = 0 # makes it so you cant move when you die

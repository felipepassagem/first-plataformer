extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var is_attacking = false
var wait = false
var attack_timer
var go_up = false


var px
var py
var eagle_x
var eagle_y
var voando_para_cima = false
var disable_collisions = false
const min_speed = .6
var eagleT1


func _ready():
	attack_timer = $AttackTimer
	#preciso pegar o player
	#position.x = player.position.x + 300
	#position.y = player.position.y + -350
	#eagle_x = player.position.x + 250
	#eagle_y = player.position.y + -800
	


func _physics_process(delta):
	# Add the gravity.
	
	if disable_collisions:
		get_node("DetectPlayerAtk").monitoring = false
		get_node("DetectPlayerAtk/DeathCollision").disabled = true
	
	if not is_attacking and not wait:
		get_node("AnimatedSprite2D").play("Attack")
		is_attacking = true
		attack_timer.start()
	if is_attacking and not wait:
		get_node("AnimatedSprite2D").play("Attack")
		attack(px, py)
		
	
		

	move_and_slide()
	

func attack(playerX, playerY):
	var timer_base = attack_timer.wait_time
	var timer_left = attack_timer.get_time_left() # numero sempre >= 0 que vai de n -> 0
	var down_modifier = 1.5 + timer_base - timer_left 
	var up_modifier = timer_left - 1

	
	
	#descida
	if not go_up:
		position.x -= down_modifier * down_modifier

	if position.y <= playerY + 10 and not go_up:
		position.y += 1.5 + down_modifier * down_modifier
	#Subida
	if up_modifier < min_speed: 
			up_modifier = min_speed
	if position.x <= playerX - 100:
		go_up = true
		
		position.x -= (up_modifier * up_modifier)
	if go_up: 
		
		position.y -= up_modifier * up_modifier
		
	
		
	
	move_and_slide()



func _on_detect_player_body_entered(body):
	if body.name == "Player2":
		#Tirar vida  do player
		
		print("TODO")
	pass # Replace with function body.


func _on_attack_timer_timeout():
	self.queue_free()
	 # Replace with function body.


func _on_detect_player_atk_body_entered(body):
	
	var in_air = player.isJumping or player.isFalling or player.isDashing

	if in_air and player.position.y <= position.y and body.name == "Player2":
		
		wait = true
		player.velocity.y = -200
		disable_collisions = true
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
	elif body.name == "Player2":
		Game.playerHP -= 5
		
	pass # Replace with function body.

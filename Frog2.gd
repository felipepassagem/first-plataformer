extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var AS2D = $AnimatedSprite2D

#controlers
var is_fall = false
var is_idle = false
var is_walk = false
var is_jump = false
var is_death = false

var attack = false
var player
var wait = false

func _ready():
	AS2D.play("Fall")
	#player = get_node("../../Player/Player2")
	player = get_node("../../Player/Player2")

func _physics_process(delta):
	if is_death:
		death_state()
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		
		#Idle
		if is_on_floor() and velocity.x == 0 and !wait and !is_idle:
			is_idle = true
			wait = true
			idle_state()
			set_states(AS2D.animation)
		
		if attack:
			if is_on_floor() and is_idle and !is_walk and !is_jump and !wait :
				is_jump = true
				wait  = true
				jump_state()
				set_states(AS2D.animation)
		
		else:
			if is_on_floor() and is_idle and !is_walk and !is_jump and !wait:
				is_walk = true
				wait  = true
				walk_state()
				set_states(AS2D.animation)
				
		if velocity.y > 0 and !wait:
			AS2D.play("Fall")
			
			
		
	
	
	
	move_and_slide()
	
func set_states(animation_name):
	if animation_name == "Idle":
		is_idle = true
		is_fall = false
		is_walk = false
		is_jump = false
	if animation_name == "Fall":
		is_idle = false
		is_fall = true
		is_walk = false
		is_jump = false
	if animation_name == "Walk":
		is_idle = false
		is_fall = false
		is_walk = true
		is_jump = false
	if animation_name == "Jump":
		is_idle = false
		is_fall = false
		is_walk = false
		is_jump = true
		
		
	
func idle_state():
	AS2D.play("Idle")

func jump_state():
	var relative_direction = (player.position - self.position).normalized()
	var jump_direction = 1 if relative_direction.x > 0 else -1
	if jump_direction == 1 and !AS2D.flip_h:
		AS2D.flip_h = true
	if jump_direction == -1 and AS2D.flip_h:
		AS2D.flip_h = false
	velocity.x = 150 * jump_direction
	velocity.y = -280
	AS2D.play("Jump")
	
	
func walk_state():
	var walk_direction = get_rand_direction()
	var flip_sprite = true if walk_direction == 1 else -1
	if walk_direction == 1 and !AS2D.flip_h:
		AS2D.flip_h = true
	if walk_direction == -1 and AS2D.flip_h:
		AS2D.flip_h = false
	velocity.x = 100 * walk_direction
	velocity.y = -200
	AS2D.play("Walk")
	
func fall_state():
	AS2D.play("Fall")
	
func get_rand_direction():
	#returns 1 or -1
	return 2 * randi_range(0,1) - 1

func _on_animated_sprite_2d_animation_finished():
	if AS2D.animation == "Walk":
		velocity.x = 0
	elif AS2D.animation == "Jump":
		velocity.x = 0
	elif AS2D.animation == "Death":
		is_death = false
		self.queue_free()
	wait = false
	pass # Replace with function body.


func _on_player_detection_body_entered(body):
	if body.name == "Player2":
		attack = true
	 # Replace with function body.


func _on_player_detection_body_exited(body):
	if body.name == "Player2":
		attack = false

func death_state():
	velocity.x = 0
	velocity.y = 0
	get_node("CollisionShape2D").disabled = true
	get_node("PlayerDeath").monitoring = false
	AS2D.play("Death")

func _on_player_death_body_entered(body):

	var player_in_air = player.isJumping or player.isDashing or player.isFalling
	
	
	if body.name == "Player2" and player.position.y <= position.y and player_in_air:
		wait = true
		is_death = true
		player.velocity.y = -200
	
	elif body.name == "Player2":
		Game.playerHP -= 5
		is_death = true
		#var relative_position = (player.position.x - self.position.x)
		#print(relative_position)
		#if (relative_position > 0):
			#print("AQUII") # empurrar para a esquerda -- valor negativo
			#
			#
		#if (relative_position < 0):
			#print("AQUII") # empurrar para a esquerda -- valor negativo
			#player.velocity.x = -200
		
	 # Replace with function body.


#func _on_player_collision_body_entered(body):
	#if body.name == "Player2":
		#Game.playerHP -= 5
	 # Replace with function body.



#func _on_player_bounce_body_entered(body):
	#if body.name == "Player2": # and animation == jump or fall or dash
		#player.velocity.y = -200
		#death_state()
		
		


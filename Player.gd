extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 5000
const DASH_DURATION = .2
@onready var dash = $Dash

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hitbox
#var buffered_jumper = false
var isJumping = false
var isDashing = false
var isFalling = false
var isHurt = false
var isCrouching = false
var isRunning = false
var wait = false
var isIdle = false
var jump_buffer
var plataform_timer




@onready var animation = get_node("AnimationPlayer")
@onready var tween = get_tree().create_tween()

func _ready():
	animation.play("Idle")
	hitbox = $CollisionShape2D
	jump_buffer = $JumpBufferTimer
	plataform_timer = $PlataformCrouchTimer
	set_collision_layer_value(0, true)
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)

func has_collision(x, y):
	var result = move_and_collide(Vector2(x, y))  # Try to move without actually moving
	return result != null  # If

func _physics_process(delta):
	# Add the gravity.
	#print(velocity.x)
	#print("is jumping: ", isJumping)
	#print("is dash: ",isDashing)
	#print("is fall: ",isFalling)
	#print("is hurt: ",isHurt)
	#print("is crouc: ",isCrouching)
	#print("is runn: ",isRunning)
	#print("is wait: ",wait)
	
	
	#
	#tween.set_trans(Tween.TRANS_QUART) 
	#tween.set_ease(Tween.EASE_OUT)	
	
	var direction = Input.get_axis("ui_left", "ui_right")
	print("Aqui 1")

	if not is_on_floor():
		print("Aqui 2")
		velocity.y += gravity * delta

	if is_on_floor():
		print("Aqui 3")
		if (animation.current_animation) == "Fall":
			animation.stop()
			velocity.x = 0
		#if animation.animation == "Fall":
			#animation.stop()
		isFalling = false
		isJumping = false
	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		isJumping = true
		velocity.y = JUMP_VELOCITY
		animation.play("Jump")

		
	if isJumping:
		if velocity.x > -300 and velocity.x < 300:
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					velocity.x += 15 * direction

			
	#handle crouch
	if Input.is_action_pressed("ui_down") and not isJumping and !wait and not isDashing:

		set_collision_mask_value(3, false)
		plataform_timer.start()
		isRunning = false
		isCrouching = true
		animation.play("Crouch")
		hitbox.position.y = 7
		hitbox.scale.y = .6
		if velocity.x > 0:
			velocity.x -= 15
		if velocity.x < 0:
			velocity.x += 15
		direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
		
		
	#Andando??
	elif not isDashing:
		
		hitbox.position.y = 0
		hitbox.scale.y = 1
		direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
		
		#erro aqui
		if velocity.x == 0 and velocity.y == 0:

			animation.play("Idle")
			isIdle = true
			
		if direction != 0 and not isJumping:
			if direction == 1 and velocity.x < 300:
				if velocity.x + 15 > 300:
					velocity.x = 300
				else: 
					velocity.x += 15
				
				
			if direction == -1 and velocity.x > -300:
				if velocity.x - 15 < -300:
					velocity.x = -300
				else: 
					velocity.x -= 15
				#velocity.x -= 15
			animation.play("Run")
			isRunning = true
			#set_states("isRunning")
			
		elif direction == 0 and isRunning and not isJumping:
			##Arrumar aqui
			
			#FAZER ANIMACAO DE DERRAPAR
			if velocity.x != 0:
				if velocity.x < 301 and velocity.x > 0:
					velocity.x -= 15
					animation.play("Stop")
				if velocity.x > -301 and velocity.x < 0:
					velocity.x += 15
					animation.play("Stop")
			
			
	#handle fall
	if velocity.y > 0 and not isDashing:
		
		isFalling = true
		animation.play("Fall")
		isJumping = false
		isDashing = false
		if velocity.x > -300 and velocity.x < 300:
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					velocity.x += 15 * direction
		if Input.is_action_just_pressed("ui_accept"):
			jump_buffer.start_buffer()
		
		
	#handle dash
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and isJumping and !wait:

		if direction != 0:
			isDashing = true
			if direction == -1:
				velocity.x = -500
			elif direction == 1:
				velocity.x = 500
			set_states("isDashing")
			dash.start_dash(DASH_DURATION)
			animation.play("Dash")

			#var speed = DASH_SPEED if dash.is_dashing() else SPEED
			#velocity.x = direction * (speed)
			#velocity.x = lerp(4000.0, 0.0, 0.000001) * direction

	if !jump_buffer.is_stopped() and is_on_floor():
		#pass
		isJumping = true
		velocity.y = JUMP_VELOCITY
		animation.play("Jump")
	
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")

	
	move_and_slide()



		

func hurt_state():
	isHurt = true
	wait = true
	animation.play("Hurt")
	pass



func _on_detect_eagle_body_entered(body):
	print(body.name)


func set_states(current_state):
	if current_state == "isJumping":
		isJumping = true
		isDashing = false
		isFalling = false
		isHurt = false
		isCrouching = false
		wait = false
		isRunning = false
	if current_state == "isDashing":
		isJumping = false
		isDashing = true
		isFalling = false
		isHurt = false
		isCrouching = false
		wait = false
		isRunning = false
	if current_state == "isRunning":
		isJumping = false
		isDashing = false
		isFalling = false
		isHurt = false
		isCrouching = false
		wait = false
		isRunning = true
	


#func _on_animation_player_animation_finished(anim_name):
	#print(anim_name)
	#pass # Replace with function body.


func _on_tree_entered():

	pass # Replace with function body.


func _on_plataform_crouch_timer_timeout():
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	plataform_timer.stop()

	pass # Replace with function body.

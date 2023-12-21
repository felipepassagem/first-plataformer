extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var SPEED = 50
var is_attack = false
var jumping = false
var jump_direction = -1
var rand_reg = false

var rand
var rand_


@onready var jump_timer = $JumpTimer
@onready var idle_timer = $IdleTimer

const BOUNCE_VELOCITY = -300.0

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	

func _physics_process(delta):
	player = get_node("../../Player/Player2")
	#velocity.y += gravity * delta
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	var direction = (player.position - self.position).normalized()
	
	if get_node("AnimatedSprite2D").animation != "Death":
		if velocity.y < 0 and !is_on_floor() and !jumping:
			get_node("AnimatedSprite2D").play("Jump")
			jump_direction = 1 if direction.x > 0 else -1
			jumping = true
		#Handle Fall
		
		if velocity.y > 0 and !is_on_floor():
			get_node("AnimatedSprite2D").play("Fall")
		elif is_on_floor():
			get_node("AnimatedSprite2D").play("Idle")
			jumping = false
			
	if jumping:
		if !chase:
			velocity.x = 120 * rand_
		else:
			var teste = (player.position.x - position.x)
			velocity.x = -300 * jump_direction
	else:
		var flip_sprite = true if direction.x > 0 else false
		get_node("AnimatedSprite2D").flip_h = flip_sprite
		velocity.x = 0
		
	

	move_and_slide()
	
###COntinuar aqui
func _on_animated_sprite_2d_animation_changed():
	#velocity.x = 0
	pass

func _on_animated_sprite_2d_animation_finished():
	var animation_name = get_node("AnimatedSprite2D").animation
	if animation_name == "Idle" and is_on_floor():
		rand = randi_range(0,1)
		rand_ = 2 * rand - 1
		## pegar posicao dos dois bonecos e fazer uma funcao para achar o valor do pulo
		jump()
	
		
		

func jump():
	get_node("AnimatedSprite2D").play("Jump")
	var jump_direction = (player.position - self.position).normalized()
	var invert_jump = true if jump_direction.x > 0 else false
	
	#velocity.x = -400
	velocity.y += -400
	
		

func _on_player_detection_body_entered(body):
	if body.name == "Player2":
		chase = true
		is_attack = true
	
		
func _on_player_detection_body_exited(body):
	#velocity.x = lerp(velocity.x, 0.0, 0.9)
	if body.name == "Player2":
		chase = false
		is_attack = true

func _on_player_death_body_entered(body):
	if body.name == "Player2":
		body.velocity.y = BOUNCE_VELOCITY
		body.animation.play("Jump")
		chase = false
		death()
		

func _on_player_collision_body_entered(body):
	if body.name == "Player2":
		Game.playerHP -= 5
		death()
		
		
func death():
	Game.Gold += 5
	Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()








extends Area2D

var Eagle = preload("res://Eagle.tscn")
var player
@onready var timer = $Timer
var collision_shape

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player/Player2")
	collision_shape = get_node("CollisionShape2D")
	 # Replace with function body.

#position.x = player.position.x + 300
#position.y = player.position.y + -350

func _on_body_entered(body):
	if body.name == "Player2":
		set_deferred("monitoring", false) 
		timer.start()
		var eagle = Eagle.instantiate()
		eagle.player = player
		eagle.position = Vector2(player.position.x + 400, player.position.y + -350)
		eagle.px = player.position.x
		eagle.py = player.position.y
		add_child(eagle)
		
		
		#print(eagle.position.x)
	 


func _on_timer_timeout():
	set_deferred("monitoring", true) 
	# Replace with function body.

extends Timer


# Called when the node enters the scene tree for the first time.
var player
@onready var JumpBufferTimer = $"."

func start_buffer():
	#JumpBufferTimer.wait_time = duration
	player = get_parent()
	#player.buffered_jumper = true
	JumpBufferTimer.start()
	
	
#func is_dashing():
	#return !JumpBufferTimer.is_stopped()


#func _on_duration_timer_timeout():
	#player = get_parent()
	#var tween = get_tree().create_tween()
	#tween.tween_property(player, "position", player.position, .15)
	#print("timeout")

extends Node2D
var player
var isDashing = false
@onready var duration_timer = $DurationTimer

func start_dash(duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	
func is_dashing():
	return !duration_timer.is_stopped()


func _on_duration_timer_timeout():
	player = get_parent()
	var tween = get_tree().create_tween()
	player.velocity.x = 0
	player.isDashing = false
	tween.tween_property(player, "position", player.position, .15)

	
	
	  # Replace with function body.

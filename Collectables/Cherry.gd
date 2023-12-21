extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body):
	if body.name == "Player2":
		Game.Gold += 5
		Game.playerHP += 10
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 50,), .35)
		tween1.tween_property(self, "modulate:a", 0, .2)
		tween.tween_callback(queue_free)


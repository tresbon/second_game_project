extends Area2D

signal coin_puckup

var textures = {
	'coin':'res://assets/coin.png',
	'key_red':'res://assets/keyRed.png',
	'key_green':'res://assets/keyGreen.png',
	'star':'res://assets/star.png'
	}

var type

func _ready():
	$Tween.interpolate_property($Sprite,'scale',
	Vector2(1,1),Vector2(3,3),0.5,
	Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, 'modulate',
	Color(1,1,1,1), Color(1,1,1,0), 0.5,
	Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
func init(_type, pos):
	$Sprite.texture = load(textures[_type])
	type = _type
	position = pos
	
func pickup():
	match type:
		'coin':
			emit_signal('coin_puckup', 1)
			$Coin_pickup.play()
		'key_red', 'key_green':
			$Key_pickup.play()
	$CollisionShape2D.disabled = true
	$Tween.start()
	
func _on_Tween_tween_completed(object, key):
	queue_free() # Replace with function body.


func _on_Pickup_coin_puckup():
	return 1 # Replace with function body.

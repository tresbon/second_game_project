extends Node2D

export (PackedScene) var Enemy
export (PackedScene) var Pickup

onready var items = $Items
var doors = {'red':[],'green':[]}

func set_camera_limits():
    var map_size = $Ground.get_used_rect()
    var cell_size = $Ground.cell_size
    $Player/Camera2D.limit_left = map_size.position.x * cell_size.x
    $Player/Camera2D.limit_top = map_size.position.y * cell_size.y
    $Player/Camera2D.limit_right = map_size.end.x * cell_size.x
    $Player/Camera2D.limit_bottom = map_size.end.y * cell_size.y
	
func spawn_items():
	for cell in items.get_used_cells():
		var id = items.get_cellv(cell)
		var type = items.tile_set.tile_get_name(id)
		var pos = items.map_to_world(cell) + items.cell_size / 2
		match type:
			'slime_spawn':
				var s = Enemy.instance()
				s.position = pos
				s.tile_size = items.cell_size
				add_child(s)
			'player_spawn':
				$Player.position = pos
				$Player.tile_size = items.cell_size
			'coin', 'key_red', 'key_green', 'star':
				var p = Pickup.instance()
				p.init (type, pos)
				add_child(p)


func _ready():
    randomize()
    $Items.hide()
    set_camera_limits()
    var red_door_id = $Walls.tile_set.find_tile_by_name('door_red')
    for cell in $Walls.get_used_cells_by_id(red_door_id):
        doors['red'].append(cell)
    var green_door_id = $Walls.tile_set.find_tile_by_name('door_green')
    for cell in $Walls.get_used_cells_by_id(green_door_id):
        doors['green'].append(cell)
    spawn_items()
    $Player.connect('dead', self, 'game_over')
    $Player.connect('grabbed_red_key', self, '_on_Player_grabbed_red_key')
    $Player.connect('grabbed_green_key', self, '_on_Player_grabbed_green_key')
    $Player.connect('win', self, '_on_Player_win')
		
func game_over():
    pass
 
func _on_Player_win():
    pass
 
func _on_Player_grabbed_red_key():
    for cell in doors['red']:
        $Walls.set_cellv(cell, -1)

func _on_Player_grabbed_green_key():
    for cell in doors['green']:
        $Walls.set_cellv(cell, -1)
		
extends Node3D

var astar: AStarGrid2D
@onready var walls = $Walls
@onready var player = $Player

var grid_width = 100
var grid_height = 100

func _ready():
	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, grid_width, grid_height)
	astar.cell_size = Vector2(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	astar.update()
	
	for wall in $Walls.get_children():
		var cell = Vector2i(wall.position.x - 0.5, wall.position.z - 0.5)
		if astar.is_in_boundsv(cell):
			astar.set_point_solid(cell, true)
	
	#$Player.player_path = Level.astar.get_point_path(Vector2i($Player.position.x, $Player.position.z), Vector2i(5, 2))
	#print($Player.player_path.size())

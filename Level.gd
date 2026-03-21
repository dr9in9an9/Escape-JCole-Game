extends Node3D

var astar: AStarGrid2D
@onready var walls = $Walls
@onready var player = $Player

var grid_width = 100
var grid_height = 100

func _ready():
	astar = AStarGrid2D.new()
	astar.region = Rect2i(-grid_width, -grid_height, grid_width, grid_height)
	astar.cell_size = Vector2(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	astar.update()
	
	for wall in $Walls.get_children():
		var wall_width = wall.scale.x;
		var wall_height = wall.scale.z;
		
		var left = wall.position.x - wall_width * 0.5
		var right = wall.position.x + wall_width * 0.5
		var top = wall.position.z - wall_height * 0.5
		var bottom = wall.position.z + wall_height * 0.5
		var region = Rect2i(floor(left), ceil(right), floor(top), ceil(bottom))

		astar.fill_solid_region(region, true)
	
	#$Player.player_path = Level.astar.get_point_path(Vector2i($Player.position.x, $Player.position.z), Vector2i(5, 2))
	#print($Player.player_path.size())

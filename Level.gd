extends Node3D

var astar: AStarGrid2D
@onready var walls = $Walls
@onready var player = $Player

var grid_width = 100
var grid_height = 100

func _ready():
	astar = AStarGrid2D.new()
	astar.region = Rect2i(-grid_width, -grid_height, grid_width*2, grid_height*2)
	astar.cell_size = Vector2(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	astar.update()
	
	for wall in $Walls.get_children():
		if wall.position.y != 1:
			continue
		var wall_width = wall.scale.x;
		var wall_height = wall.scale.z;
		
		var left = floor(wall.position.z - 0.5 - wall_width * 0.5)
		var right = ceil(wall.position.z - 0.5 + wall_width * 0.5)
		var top = floor(wall.position.x - 0.5 - wall_height * 0.5)
		var bottom = ceil(wall.position.x - 0.5 + wall_height * 0.5)
		var region = Rect2i(left, right - left + 1, top, bottom - top + 1)
		#var region = get_wall_rect(wall)
		#print(region)
		#
		astar.fill_solid_region(region, true)
	
	#$Player.player_path = Level.astar.get_point_path(Vector2i($Player.position.x, $Player.position.z), Vector2i(5, 2))
	#print($Player.player_path.size())

func get_wall_rect(wall: Node3D) -> Rect2i:
	var size = Vector2i(wall.scale.x, wall.scale.z)
	var center := Vector2(wall.global_position.x - 0.5, wall.global_position.z - 0.5)

	var top_left := Vector2i(
		center.x - int(floor(size.x / 2.0)),
		center.y - int(floor(size.y / 2.0))
	)

	return Rect2i(top_left, size)

extends Node3D

class_name Level

var astar: AStarGrid2D
@onready var walls = $Walls
@onready var player = $Player
@onready var debug_path_sprite = $DebugPathSprite
@onready var jcole = $JCole

var interact_popup = false
var interact_object = null

var lure_is_playing = false
var lure_object = null

var grid_width = 100
var grid_height = 100
var regenerate_path_mesh = false

func _ready():
	interact_popup = false
	interact_object = null
	regenerate_path_mesh = false
	
	
	generate_path_mesh()
	
	#$Player.player_path = Level.astar.get_point_path(Vector2i($Player.position.x, $Player.position.z), Vector2i(5, 2))
	#print($Player.player_path.size())

func _physics_process(delta):
	if regenerate_path_mesh:
		generate_path_mesh()

func generate_path_mesh():
	astar = AStarGrid2D.new()
	astar.region = Rect2i(-grid_width, -grid_height, grid_width*2, grid_height*2)
	astar.cell_size = Vector2(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	astar.update()

	for wall in $Walls.get_children():
		var special = wall is Lure or wall is BatteryBox
		var wall_width = wall.scale.x;
		var wall_height = wall.scale.z;
		if special:
			wall = wall.get_node("Node3D")
			wall_width *= wall.scale.x
			wall_height *= wall.scale.z
		
		if wall.global_position.y <= 0 and !special:
			continue
		
		var left = floor(wall.global_position.x - wall_width * 0.5)
		var right = floor(wall.global_position.x + wall_width * 0.5)
		var top = floor(wall.global_position.z - wall_height * 0.5)
		var bottom = floor(wall.global_position.z + wall_height * 0.5)
		var region = Rect2i(left, top, right - left, bottom - top)
		
		astar.fill_solid_region(region, true)
	
	#for node in $DebugNodes.get_children():
		#node.free()
	#
	#for x in range(-grid_width, grid_width):
		#for y in range(-grid_height, grid_height):
			#if astar.is_point_solid(Vector2i(x, y)) == false:
				#continue
			#var clone = $DebugPathSprite.duplicate()
			#$DebugNodes.add_child(clone)
			#clone.global_position = Vector3(x + 0.5, 3.0, y + 0.5)

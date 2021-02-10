extends Node2D
class_name CellSystem

export var CELL_SIZE = Vector2(16,16)
export var COLOR_CODES = [
	Color.black     , # 0
	Color.red       , # 1
	Color.blue      , # 2
	Color.green     , # 3
	Color.brown     , # 4
	Color.darkkhaki , # 5
	Color(0,1.0,0.4), # 6
	Color("#1032fd"), # 7
]
export var DEBUG = false 

var cells = Dictionary()

func getcell(x: int, y: int) -> int:
	return cells.get(Vector2(x, y), -1)

func putcell(x: int, y: int, id: int) -> void:
	if id == -1:
		cells.erase(Vector2(x, y))
		return
	cells[Vector2(x, y)] = id

func _draw() -> void:
	if !DEBUG: return
	for i in cells:
		draw_rect(Rect2(i * CELL_SIZE, CELL_SIZE), COLOR_CODES[cells[i]])

func _ready() -> void:
	if !DEBUG: return
	if get_parent().name == "root":
		recenter_origin()
		get_viewport().connect("size_changed", self, "recenter_origin")

func recenter_origin() -> void:
	get_viewport().canvas_transform.origin = get_viewport_rect().size / 2

extends CellSystem

var iwidth: int = 64 # the whole baseline (whole vradius)
var iheigth: int = 128 # the half or hradius
var balance: float = 0 # thinn | thickk

func generate() -> void:
	halfellipse(iwidth, iheigth)

func halfellipse(
	width: int, heigth: int,
	originx: int = 0, originy: int = 0
	) -> void:
	width /= 2
	var hh = heigth * heigth
	var ww = width * width + 2
	var hhww = hh * ww
	var x0 = width + 1
	var dx = 0
	var x1 = 0
	var ldisp = 0
	var rdisp = 0

	for i in range(-width, width):
		putcell(i + originx, originy, 0)
	
	for y in range(1, heigth):
		x1 = x0 - (dx - 1)
		while x1 > 0:
			if x1*x1*hh + y*y*ww <= hhww: break
			x1 -= 1
		dx = x0 - x1
		x0 = x1
		if x0 - ldisp > 2 && randi()%int(clamp(x0 / 4 + balance, 1, INF)) == 0:
			ldisp += 1
		if x0 + rdisp > 2 && randi()%int(clamp(x0 / 4 + balance, 1, INF)) == 0:
			rdisp -= 1
		if randi()%int(clamp(x0 / 4 - balance, 1, INF)) == 0:
			rdisp = move_toward(rdisp, 0, 1)
		if randi()%int(clamp(x0 / 4 - balance, 1, INF)) == 0:
			ldisp = move_toward(ldisp, 0, 1)
		for x in range(-x0 + ldisp, 0):
			putcell(originx + x, originy + y, 0)
		for x in range(0, x0 + rdisp):
			putcell(originx + x, originy + y, 0)
	
	putcell(0, originy + heigth, 1)

func _ready() -> void:
	while true:
		balance = -randi()%2
		iwidth = randi()%64 + 32
		iheigth = randi()%80 + 16
		cells.clear()
		randomize()
		generate()
		update()
		yield(get_tree().create_timer(0.5), "timeout")

extends CellSystem

var iwidth: int     = 64  # the whole baseline (whole vradius)
var iheigth: int    = 128 # the half or hradius
var balance: float  = 0   # thinn | thickk
var leavesch: float = 0.5 # 0-1, more - more leaves
var leavesln: float = 0.5 # > 0, more - longer leaves
var icount: int     = 1   # > 1, islands count

func generate(gox: int, goy: int) -> void:
	for i in icount:
		var d = 0
		if i - icount / 2 != 0:
			d = 0.75 / float(abs(i - icount / 2)) * (1 - randf() * 0.25)
		var liw = iwidth - d * iwidth
		var lih = iheigth - d * iheigth
		mkisland(liw, lih, gox + (i - icount / 2) * liw / (randi()%2 + 2), goy)
	
	var lcells = cells.keys().duplicate()
	for i in cells.keys().duplicate():
		if lcells.has(i - Vector2(0, 1)):
			lcells.erase(i - Vector2(0, 1))
	
	for i in lcells:
		if randf() < leavesch:
			for j in range(randi()%int(iheigth) * leavesln):
				putcell(i.x, i.y + j, 1)
	
func mkisland(
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
	
	var lcells = []

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
	
	return

func _ready() -> void:
	while true:
		randomize()
		balance = -randi()%2
		iwidth = randi()%64 + 32
		iheigth = randi()%80 + 16
		leavesch = randf()
		leavesln = randf()*4
		icount = 1
		if randi()%2 == 0:
			icount = randi()%4 + 2
		cells.clear()
		generate(0, -100)
		update()
		yield(get_tree().create_timer(0.2), "timeout")

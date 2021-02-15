extends CellSystem

enum {
	ROOM_1X1, ROOM_2X2_F,
	ROOM_2X2_BL, ROOM_2X2_BR,
	ROOM_2X2_TR, ROOM_2X2_TL,
	ROOM_2X2_V, ROOM_2X2_H,
	ROOM_3X3_F, ROOM_3X3_C,
}

const ROOM_TYPES = [
	[ # 0
		1,
	],
	[ # 1
		1, 1,
		1, 1,
	],
	[ # 2
		1, 1,
		0, 1,
	],
	[ # 3
		1, 1,
		1, 0,
	],
	[ # 4
		1, 0,
		1, 1,
	],
	[ # 5
		0, 1,
		1, 1,
	],
	[ # 6
		1, 0,
		1, 0,
	],
	[ # 7
		1, 1,
		0, 0,
	],
	[ # 8
		1, 1, 1,
		1, 1, 1,
		1, 1, 1,
	],
	[ # 9
		1, 1, 1,
		1, 0, 1,
		1, 1, 1,
	]
]

var iwidth: int     = 64  # the whole baseline (whole vradius)
var iheigth: int    = 128 # the half or hradius
var balance: float  = 0   # thinn | thickk
var leavesch: float = 0.5 # 0-1, more - more leaves
var icount: int     = 1   # > 1, islands count
var floors: int     = 4   # floors on the island surface

var rsize: int      = 9   # the side size of smallest square room

func generate(gox: int, goy: int) -> void:
#	var rooms = [
#		[Vector2(0, 0), 0],
#		[Vector2(1, 0), 1],
#		[Vector2(3, 0), 2],
#		[Vector2(5, 0), 3],
#		[Vector2(7, 0), 4],
#		[Vector2(9, 0), 5],
#		[Vector2(11, 0), 6],
#		[Vector2(13, 0), 7],
#		[Vector2(15, 0), 8],
#		[Vector2(18, 0), 9],
#	]
#	for i in rooms:
#		drawbaseroom((i[0] - Vector2(10, 0)) * rsize, i[1])
#	return
	var lbord = 0
	var rbord = 0
	for i in icount:
		var d = 0
		if i - icount / 2 != 0:
			d = 0.75 / float(abs(i - icount / 2)) * (1 - randf() * 0.25)
		var liw = iwidth - d * iwidth
		var lih = iheigth - d * iheigth
		var lix = gox + (i - icount / 2) * liw / (randi()%2 + 2)
		mkisland(liw, lih, lix, goy)
		
		if lix - liw / 2 < lbord:
			lbord = lix - liw / 2
		if lix + liw / 2 > rbord:
			rbord = lix + liw / 2
	
	var lcells = cells.keys().duplicate()
	for i in cells.keys().duplicate():
		if lcells.has(i - Vector2(0, 1)):
			lcells.erase(i - Vector2(0, 1))
	
	var rooms = []
	var cy = goy + rsize / 2
	var cx = gox
	while true:
		if !checkbaseroom(cx, cy): break
		while cx <= rbord:
			if checkbaseroom(cx, cy):
				rooms.append([Vector2(cx, cy), 0])
			cx += rsize
		cx = gox - rsize
		while cx >= lbord:
			if checkbaseroom(cx, cy):
				rooms.append([Vector2(cx, cy), 0])
			cx -= rsize
		cy += rsize
		cx = gox
	
	cy = goy - rsize / 2
	for i in range(floors):
		while cx <= rbord / 2 - rsize * i:
			rooms.append([Vector2(cx, cy), 0])
			cx += rsize
		cx = gox - rsize
		while cx >= lbord / 2 + rsize * i:
			rooms.append([Vector2(cx, cy), 0])
			cx -= rsize
		cy -= rsize
		cx = gox
	
	for i in rooms:
		drawbaseroom(i[0], i[1])
	
	for i in lcells:
		if randf() < leavesch:
			putcell(i.x, i.y, 1)

func checkbaseroom(
	x: int, y: int
	) -> bool:
	for i in range(-rsize / 2 + x, rsize / 2 + 1 + x):
		for j in range(-rsize / 2 + y, rsize / 2 + 1 + y):
			if getcell(i, j) == -1:
				return false
	return true

func drawbaseroom(
	pos: Vector2, type: int
	) -> void:
	match type:
		ROOM_1X1:
			for i in range(-rsize / 2, rsize / 2 + 1):
				for j in range(-rsize / 2, rsize / 2 + 1):
					if abs(i) == rsize / 2 || abs(j) == rsize / 2:
						putcell(pos.x + i, pos.y + j, 2)
		ROOM_2X2_F:
			for i in range(0, rsize * 2):
				for j in range(0, rsize * 2):
					if (i == 0 || j == 0 ||
					    i == rsize * 2 - 1 || j == rsize * 2 - 1):
						putcell(pos.x - rsize / 2 + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_BL:
			for i in range(0, rsize * 2):
				for j in range(0, rsize * 2):
					if ((i == 0 && j < rsize) ||
						j == 0 ||
					    i == rsize * 2 - 1 ||
						(j == rsize * 2 - 1 && i > rsize) ||
						(j >= rsize && i == rsize) ||
						(i <= rsize && j == rsize - 1)):
						putcell(pos.x - rsize / 2 + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_BR:
			for i in range(0, rsize * 2):
				for j in range(0, rsize * 2):
					if (i == 0 || j == 0 ||
					    (i == rsize * 2 - 1 && j < rsize) ||
						(j == rsize * 2 - 1 && i < rsize) ||
						(j >= rsize && i == rsize - 1) ||
						(i >= rsize - 1 && j == rsize - 1)):
						putcell(pos.x - rsize / 2 + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_TR:
			for i in range(0, rsize * 2):
				for j in range(0, rsize * 2):
					if (i == 0 ||
						(j == 0 && i < rsize) ||
					    (i == rsize * 2 - 1 && j > rsize) ||
						j == rsize * 2 - 1 ||
						(j <= rsize && i == rsize - 1) ||
						(i >= rsize - 1 && j == rsize)):
						putcell(pos.x - rsize / 2 + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_TL:
			for i in range(0, rsize * 2):
				for j in range(0, rsize * 2):
					if ((i == 0 && j > rsize)||
						(j == 0 && i > rsize) ||
					    i == rsize * 2 - 1 ||
						j == rsize * 2 - 1 ||
						(j <= rsize && i == rsize) ||
						(i <= rsize && j == rsize)):
						putcell(pos.x - rsize / 2 + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_V:
			for i in range(-rsize / 2, rsize / 2 + 1):
				for j in range(0, rsize * 2):
					if (abs(i) == rsize / 2 ||
						j == rsize * 2 - 1 || j == 0):
						putcell(pos.x + i,
								pos.y - rsize / 2 + j, 2)
		ROOM_2X2_H:
			for i in range(0, rsize * 2):
				for j in range(-rsize / 2, rsize / 2 + 1):
					if (i == rsize * 2 - 1 ||
						i == 0 || abs(j) == rsize / 2):
						putcell(pos.x - rsize / 2 + i,
								pos.y + j, 2)
		ROOM_3X3_F:
			for i in range(-rsize * 3 / 2, rsize * 3 / 2 + 1):
				for j in range(-rsize * 3 / 2, rsize * 3 / 2 + 1):
					if abs(i) == (rsize * 3) / 2 || abs(j) == (rsize * 3) / 2:
						putcell(pos.x + rsize + i,
								pos.y + rsize + j, 2)
		ROOM_3X3_C:
			for i in range(-rsize * 3 / 2, rsize * 3 / 2 + 1):
				for j in range(-rsize * 3 / 2, rsize * 3 / 2 + 1):
					if (abs(i) == (rsize * 3) / 2 ||
						abs(j) == (rsize * 3) / 2 ||
						(abs(i) == rsize / 2 + 1 && abs(j) <= rsize / 2 + 1) ||
						(abs(j) == rsize / 2 + 1 && abs(i) <= rsize / 2 + 1)):
						putcell(pos.x + rsize + i,
								pos.y + rsize + j, 2)

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

var autostart = false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") || !autostart:
		autostart = true
		balance = -randf() * 1.5 - 0.5
		iwidth = randi()%128 + 64
		iheigth = randi()%120 + 72
		leavesch = randf()*0.5
		icount = randi()%5 + 1
		floors = randi()%5 + 1
		cells.clear()
		generate(0, 0)
		update()

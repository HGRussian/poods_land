extends CanvasLayer

var counters_names = []
var counters = []

func _ready():
	set_process(true)
	
func _process(delta):
	var string = ""
	for i in counters_names.size():
		string+=counters_names[i]+": "
		string+=str(counters[i][0])+"/"+str(counters[i][1])+" "
	$label.text = string

func set_counter(data):
	if !data[0] in counters_names:
		counters_names.append(data[0])
		counters.append([data[1],data[2]])
	else:
		var idx = counters_names.find(data[0])
		counters[idx][0] = data[1]
		counters[idx][1] = data[2]
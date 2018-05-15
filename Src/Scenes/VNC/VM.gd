extends Node

export(ImageTexture) var blank_icon
export(ImageTexture) var blank_infected_icon
export(ImageTexture) var blank_corrupted_icon
export(ImageTexture) var blank_activated_icon
func _ready():
	add_vm([])
	get_node("../BG/FolderBox").add_child(get(0)["files"]["view"])

var vms = []
func add_vm(code):
	var f = {'view': ItemList.new()}
	f["view"].rect_position = Vector2(3, 30)
	f["view"].rect_size = Vector2(463, 373)
	f["view"].add_item("notes.txt", blank_icon, false)
	f["view"].add_item("calendar.dat", blank_icon, false)
	vms.append({'code': code,
				'ip': 0,
				'r': [],
				'files': f})

func get(n):
	return vms[0]

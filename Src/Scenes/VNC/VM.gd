extends Node

export(ImageTexture) var blank_icon
export(ImageTexture) var blank_infected_icon
export(ImageTexture) var blank_corrupted_icon
export(ImageTexture) var blank_activated_icon
func _ready():
	randomize()
	add_vm([]); show_vm(0)
	set_process(false)

var vms = []
func file(name):
	return {'name': name, 'type': 'document', 'code': null}
func add_vm(code):
	var f = [file('calendar.dat'), file('accounts.txt'), file('PICZ.zip')]
	f[2]['type'] = 'infected'; f[2]['code'] = code
	var virii = [{'code': f[2]['code'], 'pc': 0}]
	vms.append({'files': f, 'virii': virii})

func show_vm(i):
	var view = get_node('../BG/FolderBox/FileView')
	view.clear()
	for f in vms[i]['files']:
		view.add_item(f['name'], blank_icon, false)
	for i in range(view.get_item_count()):
		view.set_item_tooltip_enabled(i, false)

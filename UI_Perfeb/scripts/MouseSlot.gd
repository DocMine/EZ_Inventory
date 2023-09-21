extends Control
#这是鼠标的储存空间，基本就是没有BG的slot
# 打开UI时会跟随鼠标移动，具备保存物品信息的能力
# 当保存了物品信息的时候， 会显示物品对应的图标(和数量，如果有的话)
# 数量是独立于背包储存的数据

@onready var ItemIcon:TextureRect = $ItemIcon
@onready var UpdateTimer:Timer = $UpdateTimer
@onready var AmountLabel:Label =  $ItemIcon/AmountLabel
@onready var NameLabel:Label =  $ItemIcon/NameLabel


@export var ItemInfo:Dictionary = {}
@export var ItemIconPath_Key:String = "icon_path"


var ItemAmount:int = 0

func _ready():
	# 初始化UI大小
	initTimer()

func _process(_delta):
	position = get_global_mouse_position()+Vector2(5,5)

func initTimer():
	# setUp UpdateTimer
	UpdateTimer.wait_time = 0.1
	UpdateTimer.timeout.connect(OnUpdateTimer_Timeout)
	UpdateTimer.start()

	
func OnUpdateTimer_Timeout():
	# update Item info to slotUI
	UpdateItemInfo()


func UpdateItemInfo():
	if ItemInfo :
		AmountLabel.text = str(ItemAmount)
		if ItemInfo.has("id"):
			NameLabel.text = str(ItemInfo["id"])
		if ItemInfo.has("amount"):
			AmountLabel.text = str(ItemInfo["amount"])
		if ItemInfo.has(ItemIconPath_Key):
			ItemIcon.texture = load(ItemInfo[ItemIconPath_Key])
	else:
		# 空格子的显示方式
		AmountLabel.text = ""
		NameLabel.text = ""
		ItemIcon.texture = null

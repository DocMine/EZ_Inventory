@icon("res://addons/EZ_Inventory/Icon/database.svg")
extends Resource
class_name ItemDatabase
# 定义一个资源类，用来作为某种物品的数据库

@export var ItemDic:Dictionary = {}

func AddItem(IteminfoDictionary):
	# add Item info 
	# Info should be a dictionary, and contains "id" as key
	if ItemDic.has(IteminfoDictionary.id):
		print_debug("Id already exist, Use ForceAddItem() func to replace Item")
		return
	if IteminfoDictionary.has("id"):
		ItemDic[IteminfoDictionary.id] = IteminfoDictionary
	else:
		print_debug("ItemInfo do not have key 'id' ")


func ForceAddItem(IteminfoDictionary):
	if IteminfoDictionary.has("id"):
		ItemDic[IteminfoDictionary.id] = IteminfoDictionary
	else:
		print_debug("ItemInfo do not have key 'id' ")


func RemoveItemById(ItemID):
	# removeItem By Id
	if ItemDic.has(ItemID):
		ItemDic.erase(ItemID)


func SaveAsResource(FilePath:String):
	# 将整个资源文件保存到path
	# 这里应该判断路径中的目录是否存在，不存在的话要新建目录
	ResourceSaver.save(self, FilePath)


func LoadfromCSV(CSVPath:String):
	# 从csv文件中读取数据库
	var file:FileAccess = FileAccess.open(CSVPath,FileAccess.READ)
	var content:String = file.get_as_text()
	var CsvList:PackedStringArray = content.split("\r\n")
	# 按行分割
	var Keys:Array = CsvList[0].split(",")
	CsvList.remove_at(0)
	# 得到首行的Keys并移除首行
	for LineIndex in range(len(CsvList)):
		var datalist:PackedStringArray = CsvList[LineIndex].split(",")
		var DicTemp:Dictionary = {}
		for dataIndex in range(len(datalist)):
			DicTemp[Keys[dataIndex]] = datalist[dataIndex]
		if DicTemp.has("id"):
			ItemDic[DicTemp["id"]] = DicTemp.duplicate(true)
			# 将相应的数据储存整合为新字典，并保存到字典中


func PrintAllItems():
	for x in ItemDic.values():
		print(x)

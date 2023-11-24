from pymongo import MongoClient
from dotenv import load_dotenv

load_dotenv()

mongo_uri = 'DB_CONNECTION_STRING'
client = MongoClient(mongo_uri)
db = client['main']
outfitCollection = db['outfit']
itemCollection = db['item']
stateCollection = db['state']

def addItem(name,temperature,imageUrl):
    newItem = {
        'name': f"{name}",
        'temperature': f"{temperature}",
        'imageUrl': f"{imageUrl}",
    }
    itemCollection.insert_one(newItem)

def addOutfit(name,weather,temperature,imageUrl, purpose,date):
    newOutfit = {
        'name': f"{name}",
        'weather': f"{weather}",
        'temperature': f"{temperature}",
        'imageUrl': f"{imageUrl}",
        'purpose': f"{purpose}",
        'date': f"{date}",
    }
    outfitCollection.insert_one(newOutfit)

def getOutfits():
    outfits = outfitCollection.find()
    return outfits
def getItems():
    items = itemCollection.find()

def editThing(field,val,id,type):
    filter = {"_id":f"{id}"}
    update = {f"{field}":f"{val}"}
    if(type=='outfit'):
        outfitCollection.update_one(filter,update)
    elif(type=='item'):
        itemCollection.update_one(filter,update)
    else:
        stateCollection.update_one(filter,update)


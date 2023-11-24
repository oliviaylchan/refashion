from pymongo import MongoClient
from dbfunctions import *

mongo_uri = 'mongodb+srv://rnquan30:se101@cluster0.ugb4dqu.mongodb.net/?retryWrites=true&w=majority'
client = MongoClient(mongo_uri)
db = client['main']
# collection = db['outfit']
# collection.insert_one({
#     'name': 'hi',
#     'weather': 'hi',
#     'temperature': 5,
#     'imageUrl': 'hi',
#     'purpose': 'hi',
#     'date': 'hi',
# })

# outfitSchema = {
#     'name': {'type': 'string'},
#     'weather': {'type': 'string'},
#     'temperature': {'type': 'string'},
#     'imageUrl': {'type': 'string'},
#     'purpose': {'type':'string'},
#     'date': {'type': 'string'},
# }   

# itemSchema = {
#     'outfitName': {'type': 'string'},
#     'name': {'type': 'string'},
#     'temperature': {'type': 'string'},
#     'imageUrl': {'type': 'string'},
# }

# stateSchema = {
#     'name': {'type': 'string'},
#     'value': {'type': 'boolean'}
# }

# collection_name = 'outfit'
# db.create_collection(collection_name, validator={'$jsonSchema': {'bsonType': 'object', 'properties': outfitSchema}})

collection = db['state']
buttonState = getStates()[0]
print(buttonState)
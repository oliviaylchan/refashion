from os import path
from pymongo import MongoClient
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, storage
load_dotenv()

mongo_uri = 'mongodb+srv://rnquan30:se101@cluster0.ugb4dqu.mongodb.net/?retryWrites=true&w=majority'
client = MongoClient(mongo_uri)
db = client['main']
outfitCollection = db['outfit']
itemCollection = db['item']
stateCollection = db['state']

def addItem(outfitName,name,temperature,imageUrl):
    newItem = {
        'outfitName': f"{outfitName}",
        'name': f"{name}",
        'temperature': f"{temperature}",
        'imageUrl': f"{imageUrl}",
    }
    inserted_item = itemCollection.insert_one(newItem)
    if inserted_item.inserted_id:
        print(f"Item with ID {inserted_item.inserted_id} inserted successfully.")
    else:
        print("Failed to insert item.")

def addOutfit(name,weather,temperature,imageUrl, purpose,date):
    newOutfit = {
        'name': f"{name}",
        'weather': f"{weather}",
        'temperature': f"{temperature}",
        'imageUrl': f"{imageUrl}",
        'purpose': f"{purpose}",
        'date': f"{date}",
    }
    print(newOutfit)
    outfitCollection.insert_one(newOutfit)

def getOutfits():
    outfits = outfitCollection.find()
    return outfits
def getItems():
    items = itemCollection.find()
    return items
def getStates():
    states = stateCollection.find()
    return states

def editThing(field,val,id,type):
    filter = {"_id":f"{id}"}
    update = {f"{field}":f"{val}"}
    if(type=='outfit'):
        outfitCollection.update_one(filter,update)
    elif(type=='item'):
        itemCollection.update_one(filter,update)
    else:
        stateCollection.update_one(filter,update)


cred = credentials.Certificate("refashion-2d41d-firebase-adminsdk-30i01-1808e50119.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'refashion-2d41d.appspot.com'})

# Create a storage client
bucket = storage.bucket()

async def upload_image(file_path, destination_blob_name):
  # Upload a local file to the bucket
  blob = bucket.blob(destination_blob_name)
  blob.upload_from_filename(file_path)

  print(f"File {file_path} uploaded to {destination_blob_name}")
  # get public url
  blob.make_public()
  return blob.public_url
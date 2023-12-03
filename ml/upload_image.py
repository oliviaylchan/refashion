import firebase_admin
from firebase_admin import credentials, storage

# Initialize Firebase Admin SDK
cred = credentials.Certificate("refashion-2d41d-firebase-adminsdk-30i01-1808e50119.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'refashion-2d41d.appspot.com'})

# Create a storage client
bucket = storage.bucket()

def upload_image(file_path, destination_blob_name):
  # Upload a local file to the bucket
  blob = bucket.blob(destination_blob_name)
  blob.upload_from_filename(file_path)

  print(f"File {file_path} uploaded to {destination_blob_name}")
  # get public url
  blob.make_public()
  return blob.public_url

# if __name__ == "__main__":
#   local_file_path = "example.jpg"
#   destination_blob_name = "images/image.jpg"

#   public_url = upload_image(local_file_path, destination_blob_name)
#   print(f"Public URL: {public_url}")

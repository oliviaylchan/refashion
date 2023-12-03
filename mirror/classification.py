import requests
import os
import re

from gpt import generate



API_URL = "https://api-inference.huggingface.co/models/valentinafeve/yolos-fashionpedia"
headers = {"Authorization": f"Bearer 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"}

LABELS_TO_REMOVE = ['sleeve','glasses','hair accessory','buckle','zipper',
                    'epaulette','neckline','applique','flower','bead','bow',
                    'rivet','ribbon','tassel','ruffle','sequin']

def classify(filename):
  with open(filename, "rb") as f:
      data = f.read()
  response = requests.post(API_URL, headers=headers, data=data)

  output = response.json()

  prompt = """
Given the following output, create a name for this outfit, recommended weather conditions for the outfit, and a general purpose (eg. formal, casual) for the outfit in JSON format

{
  'name': {'type': 'string'},
  'weather': {'type': 'string'},
  'temperature': {'type': 'number'},
  'purpose': {'type':'string'},
}
  """
  prompt += str(output)
  print("Starting analysis...")
  analysis = generate(prompt).content

  pattern = r"\{[\S\s]*\}"
  match = re.search(pattern, analysis)
  info = eval(match.group(0))

  # remove certain labels
  for label in LABELS_TO_REMOVE:
    if label in output:
      output.pop(label)

  if 'error' in output:
    print("[[ERROR WITH HUGGING FACE API]]")
    
  return response.json(), info

import os
import dotenv
from openai import OpenAI

dotenv.load_dotenv()

client = OpenAI()

client.api_key=os.getenv("OPENAI_API_KEY")

def generate(prompt):
  response = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{"role":"user", "content":prompt}],
  )

  return response.choices[0].message
import datetime
import os.path

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
#above for calendar

import pygame
import sys
import requests
import cv2
import asyncio
#from datetime import datetime
from analyze import *
from dbfunctions import *

#calendar begin

SCOPES = ["https://www.googleapis.com/auth/calendar.readonly"]
creds = None
if os.path.exists("token.json"):
  creds = Credentials.from_authorized_user_file("token.json", SCOPES)
if not creds or not creds.valid:
  if creds and creds.expired and creds.refresh_token:
    creds.refresh(Request())
  else:
    flow = InstalledAppFlow.from_client_secrets_file(
        "credentials.json", SCOPES
    )
    creds = flow.run_local_server(port=0)
  with open("token.json", "w") as token:
    token.write(creds.to_json())
try:
  service = build("calendar", "v3", credentials=creds)
  now = datetime.utcnow().isoformat() + "Z"  # 'Z' indicates UTC time
  events_result = (
      service.events()
      .list(
          calendarId="primary",
          timeMin=now,
          maxResults=3,
          singleEvents=True,
          orderBy="startTime",
      )
      .execute()
  )
  events = events_result.get("items", [])
  if not events:
    print("No upcoming events found.")
    
  for event in events:
    start = event["start"].get("dateTime", event["start"].get("date"))
    print(start, event["summary"])
except HttpError as error:
  print(f"An error occurred: {error}")

#calendar end

pygame.init()

# monitor is 1440x900, app is full screen landscape mode
width, height = 1440, 900
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Refashion")

# all font colour is going to be white so it's clear on a smart mirror
white = (255, 255, 255)
font_color = white  

# fonts for text
font_time = pygame.font.Font(None, 72)
font_phrase = pygame.font.Font(None, 48)
font_weather = pygame.font.Font(None, 48)

#cap = cv2.VideoCapture(0)

# API key for weatherapi.com
api_key = "b446c1349da64e8c936174110232111"
location = "N2L 3G1"

def capture_and_save_image():
    cap = cv2.VideoCapture(0)
    ret, frame = cap.read()
    cap.release()
    cv2.imwrite("captured_image.png", frame)
    asyncio.run(analyze("captured_image.png"))

# constantly loops while app is running
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:#Exit if space bar is pressed
                pygame.quit()
                sys.exit()
    if(getStates()[0]['value'] == True):
        capture_and_save_image()
        editState("photoButton")         
    try:
        captured_image = pygame.image.load("captured_image.png")
    except pygame.error:
        captured_image = None

    
    current_time = datetime.now().strftime("%H:%M:%S") # gets current time of day

    # displays a phrase based on time of day
    hour = int(datetime.now().strftime("%H"))
    if 6 <= hour < 12:
        phrase = "Good morning!"
    elif 12 <= hour < 18:
        phrase = "Good afternoon!"
    else:
        phrase = "Have a good night!"

    # weather api call
    current_weather_url = f"http://api.weatherapi.com/v1/current.json?key={api_key}&q={location}"
    current_response = requests.get(current_weather_url)
    current_weather_data = current_response.json()

    temperature = current_weather_data["current"]["temp_c"]
    condition = current_weather_data["current"]["condition"]["text"]

    # sets the background to black (ensures the smart mirror is a mirror)
    screen.fill((0, 0, 0))

    # setup text
    text_time = font_time.render(current_time, True, font_color)
    text_time_rect = text_time.get_rect(center=(width // 1.2, height // 10)) 

    text_phrase = font_phrase.render(phrase, True, font_color)
    text_phrase_rect = text_phrase.get_rect(center=(width // 1.2, height // 5))

    weather_info = f"{temperature}°C, {condition}"
    text_weather = font_weather.render(weather_info, True, font_color)
    text_weather_rect = text_weather.get_rect(center=(width // 2, height // 10))
    location_info = f"In Waterloo, Ontario"
    text_location = font_weather.render(location_info, True, font_color)
    text_location_rect = text_weather.get_rect(center=(width // 2, height // 7))

    calendar_info = f"Upcomming Events:"
    calendar_location = font_weather.render(calendar_info, True, font_color)
    calendar_location_rect = text_weather.get_rect(center=(width // 5, height // 4))
    calendar1_info = events[0]["summary"]
    calendar1_location = font_weather.render(calendar1_info, True, font_color)
    calendar1_location_rect = text_weather.get_rect(center=(width // 5, height // 3))
    calendar2_info = events[1]["summary"]
    calendar2_location = font_weather.render(calendar2_info, True, font_color)
    calendar2_location_rect = text_weather.get_rect(center=(width // 5, height // 2.6))
    calendar3_info = events[2]["summary"]
    calendar3_location = font_weather.render(calendar3_info, True, font_color)
    calendar3_location_rect = text_weather.get_rect(center=(width // 5, height // 2.3))

    # if there is a stored image, display it on the right side of the screen
    if captured_image is not None:
        image_rect = captured_image.get_rect(center=(width // 1.5, height // 1.5))
        screen.blit(captured_image, image_rect)

    # actually puts the text on the screen
    screen.blit(text_time, text_time_rect)
    screen.blit(text_phrase, text_phrase_rect)
    screen.blit(text_weather, text_weather_rect)
    screen.blit(text_location, text_location_rect)
    screen.blit(calendar_location, calendar_location_rect)
    screen.blit(calendar1_location, calendar1_location_rect)
    screen.blit(calendar2_location, calendar2_location_rect)
    screen.blit(calendar3_location, calendar3_location_rect)

    pygame.display.flip()

    pygame.time.Clock().tick(30)

cap.release()
cv2.destroyAllWindows()



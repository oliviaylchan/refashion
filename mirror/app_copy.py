import pygame
import sys
import requests
import cv2
import asyncio
from datetime import datetime
from analyze import *

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

cap = cv2.VideoCapture(0)

# API key from weatherapi.com
api_key = "b446c1349da64e8c936174110232111"
location = "N2L 3G1"

def capture_and_save_image():
    ret, frame = cap.read()
    cv2.imwrite("captured_image.png", frame)
    asyncio.run(analyze("captured_image.png"))

# constantly loops while app is running
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE: # Capture and save a new image when space bar is pressed
                capture_and_save_image()
            if event.key == pygame.K_ESCAPE:#Exit if space bar is pressed
                pygame.quit()
                sys.exit()
                
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
    text_time_rect = text_time.get_rect(center=(width // 4, height // 10)) 

    text_phrase = font_phrase.render(phrase, True, font_color)
    text_phrase_rect = text_phrase.get_rect(center=(width // 4, height // 5))

    weather_info = f"{temperature}°C, {condition}"
    text_weather = font_weather.render(weather_info, True, font_color)
    text_weather_rect = text_weather.get_rect(center=(width // 4, height // 2))
    location_info = f"In Waterloo, Ontario"
    text_location = font_weather.render(location_info, True, font_color)
    text_location_rect = text_weather.get_rect(center=(width // 4, height // 1.85))

    # if there is a stored image, display it on the right side of the screen
    if captured_image is not None:
        image_rect = captured_image.get_rect(center=(width // 1.5, height // 1.5))
        screen.blit(captured_image, image_rect)

    # actually puts the text on the screen
    screen.blit(text_time, text_time_rect)
    screen.blit(text_phrase, text_phrase_rect)
    screen.blit(text_weather, text_weather_rect)
    screen.blit(text_location, text_location_rect)

    pygame.display.flip()

    pygame.time.Clock().tick(30)

cap.release()
cv2.destroyAllWindows()

import cv2
import asyncio
from datetime import datetime
from classification import classify
from dbfunctions import *
# IMG_PATH = "./test.jpg"

async def analyze(IMG_PATH):
    async def outfit(info):
        url = await upload_image("result.jpg", f"images/{info['name']}")
        addOutfit(info['name'],info['weather'],info['temperature'],url,info['purpose'],datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

    async def item(info, label):
        url = await upload_image("piece.jpg", f"images/{info['name']}/{label}")
        addItem(info['name'],label,info['temperature'],url)

    img = cv2.imread(IMG_PATH)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    original_img = img.copy()

    output, info = classify(IMG_PATH)
    print(info)

    #upload whole outfit image
    full_crop_bounds = {
        'xmin': img.shape[1],
        'ymin': img.shape[0],
        'xmax': 0,
        'ymax': 0
    }
    if len(output) == 0:
        print("No clothing detected")
        exit()
    for cloth in output:
        box = cloth['box']
        cv2.rectangle(img, (box['xmin'], box['ymin']), (box['xmax'], box['ymax']), (0, 255, 0), 2)
        full_crop_bounds = {
            'xmin': min(full_crop_bounds['xmin'], box['xmin']),
            'ymin': min(full_crop_bounds['ymin'], box['ymin']),
            'xmax': max(full_crop_bounds['xmax'], box['xmax']),
            'ymax': max(full_crop_bounds['ymax'], box['ymax'])
        }

    extra_gap = 20
    full_crop_bounds = {
        'xmin': max(0, full_crop_bounds['xmin'] - extra_gap),
        'ymin': max(0, full_crop_bounds['ymin'] - extra_gap),
        'xmax': min(img.shape[1], full_crop_bounds['xmax'] + extra_gap),
        'ymax': min(img.shape[0], full_crop_bounds['ymax'] + extra_gap)
    }
    full_img = original_img[full_crop_bounds['ymin']:full_crop_bounds['ymax'], full_crop_bounds['xmin']:full_crop_bounds['xmax']]
    full_img = cv2.cvtColor(full_img, cv2.COLOR_BGR2RGB)

    cv2.imwrite("result.jpg", full_img)
    await outfit(info)


    # upload individual items 
    for cloth in output:
        box = cloth['box']
        crop_img = original_img[box['ymin']:box['ymax'], box['xmin']:box['xmax']]
        crop_img = cv2.cvtColor(crop_img, cv2.COLOR_BGR2RGB)
        cv2.imwrite("piece.jpg", crop_img)
        await item(info, cloth['label'])

# asyncio.run(analyze(IMG_PATH))
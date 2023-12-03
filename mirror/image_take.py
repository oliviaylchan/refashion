import cv2

cam = cv2.VideoCapture(0)
cam.set(3, 1920)
cam.set(4, 1080)


cv2.namedWindow("imagePreview")


imageNumber = 0

while True:
    ret, img = cam.read()
    
    cv2.imshow("imagePreview", img)

    k = cv2.waitKey(1)
    if k%256 == 27:#if escape is clicked, close
        break
    elif k%256 == 32:#if space is clicked, take a picture
        img_name = "image{}.png".format(imageNumber)
        cv2.imwrite(img_name, img)
        imageNumber += 1

cam.release()

cv2.destroyAllWindows()
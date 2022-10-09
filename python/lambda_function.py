from PIL import Image
import io
import boto3 
import os

# Create a new function
def handler(self, event):
  # Create a new S3 client:
  s3 = boto3.client('s3')

  # Get the pathname to the uploaded object from the event:
  file_path = event['Records'][0]['s3']['object']['key']

  # Extract the file name and extension
  file_name, file_extension = os.path.splitext(file_path)

  # Check the file is an image (and not another type of file, like a PDF):
  if file_extension.lower() not in ['.jpg']:
    # If not an image, bail out early:
    return

  # Retrieve the object's tags. Here we can check if the file
  # has already been processed in order to prevent an infinite loop:
  tagging = s3.get_object_tagging(Bucket='vk-bucket-a', Key=file_path)
  object_tags = tagging['TagSet']

  # Go through the tags and exit if EXIF data has already been stripped:
  for tag in object_tags:
    if tag['Key'] == 'ExifStripped' and tag['Value'] == 'True':
      return

  # Retrieve the image from S3 into the image_data object:
  image_data = s3.get_object(Bucket='vk-bucket-a', Key=file_path)

  # Create a new PIL image from the image_data:
  new_image_data = process(image_data)

  # Finally overwrite the existing S3 object with the new image file data and tag:
#   s3.put_object(Bucket='vk-bucket-b', Key=file_path, Body=new_image_data, Tagging='ExifStripped=True')

def process(image_data):
    image = Image.open(image_data)

    # We need to use the orientation EXIF info to rotate the image:
    image_exif = image.getexif()
    if image_exif:
        exif = dict(image_exif.items())
        if exif.get(orientation) == 3:
            image = image.rotate(180, expand=True)
        elif exif.get(orientation) == 6:
            image = image.rotate(270, expand=True)
        elif exif.get(orientation) == 8:
            image = image.rotate(90, expand=True)

    # Retrieve the image contents as a list representing a sequence of pixel values:
    image_contents = list(image.getdata())

    # Create a new image based on the original, but without the full EXIF data:
    new_image = Image.new(image.mode, image.size)
    new_image.putdata(image_contents)

    # Finally, create a new buffer object and put the new image file data into it:
    new_image_data = io.BytesIO()
    new_image.save(new_image_data, 'PNG') # Or the file format needed
    new_image_data.seek(0)
    return new_image_data
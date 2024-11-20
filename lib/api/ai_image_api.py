
# # Python code example for downloading an image
# # For more details, visit: https://github.com/pollinations/pollinations/blob/master/APIDOCS.md

# import requests;

# def download_image(image_url):
#     # Fetching the image from the URL
#     response = requests.get(image_url)
#     # Writing the content to a file named 'image.jpg'
#     with open('image.jpg', 'wb') as file:
#         file.write(response.content)
#     # Logging completion message
#     print('Download Completed')

# # Image details
# prompt = 'Generate_an_image_of_a_futuristic_rocket_ship_blasting_off' # Prompt for the image
# width = 360
# height = 800
# seed = 702115403 # Each seed generates a new image variation
# model = 'flux' # Using 'flux' as default if model is not provided

# image_url = f"https://pollinations.ai/p/Generate_an_image_of_a_futuristic_rocket_ship_blasting_off?width=360&height=800&seed=702115403&model=flux" 

# download_image(image_url)


# # Using the pollinations pypi package

# ## pip install pollinations

# import pollinations as ai

# model_obj = ai.Model()

# image = model_obj.generate(
#     prompt=f'Generate an image of a futuristic rocket ship blasting off  {ai.realistic}',
#     model=ai.flux,
#     width=360,
#     height=800,
#     seed=702115403
# )
# image.save('image-output.jpg')

# print(image.url)

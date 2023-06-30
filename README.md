# dyneti-challenge-ios

- Optional Bonus I: Include some UI to teach the user how to use the app. ✔️
- Optional Bonus II: Include face detection and surface the hat image in the proper location only when a face is detected. ✔️

## Video Presentation
🔗 [Download Video Presentation](https://drive.google.com/file/d/1lYoF8FL7HMjZnBmlSgTD7YEDllZ8d53i/view?usp=share_link)


## Design
I've created a very simple design, the app consists of two screens:


### Camera Screen (Main)
The camera screen serves as the main interface, providing a live feed from the device's camera as the background. This screen incorporates three intuitive buttons:

- Info: Tapping this button opens the info screen, providing users with relevant information and instructions.
- Take Picture: This handy button allows users to effortlessly capture the current image on the camera feed, saving it directly to their device's gallery for later enjoyment.
- Flip Camera: Users can seamlessly switch between the device's front and back cameras, ensuring flexibility and convenience while using the app.
  
To enhance the user experience, the app employs advanced face detection technology. As the camera feed streams, the app promptly identifies all faces present and seamlessly adds a hat image atop each face. Moreover, when faces are no longer detected on the camera feed, the app dynamically removes the hats, ensuring a smooth and natural transition.

To provide a realistic and immersive experience, the hat images are intelligently adjusted in real-time, adapting their sizes according to the distance of the face. This dynamic adjustment ensures that the hats appear proportionate and visually appealing, regardless of the face's proximity to the camera.


### Info Screen
The info screen offers users valuable insights and guidance regarding the app's functionalities. It presents concise descriptions and user-friendly instructions to facilitate an intuitive and enjoyable app experience.

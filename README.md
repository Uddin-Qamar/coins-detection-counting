🪙 Coin Detection and Counting Using MATLAB

📌 Overview
This project detects and counts coins in images using classical image processing techniques in MATLAB. It processes multiple images automatically and highlights detected coins.

🎯 Objective
  - Detect and count coins
  - Highlight detected coins
  - Process multiple images from a folder
  - Use classical methods (no deep learning)

🧠 Method
  - Convert images to grayscale
  - Apply noise reduction (median + Gaussian filters)
  - Detect coins using Hough Transform (imfindcircles)
  - Tune parameters (radius, sensitivity, threshold)

⚠️ Challenges
   -  Overlapping coins
   -  Lighting and shadows
   -  Texture causing false detections

🚧 Limitations
   -  Some images (e.g., small size or complex scenes) were not detected accurately
   -  Missed partial coins and detected false inner circles in some cases

✅ Conclusion
  The method works well for most images but is sensitive to lighting and texture variations.

🧰 Tools
  - MATLAB (Image Processing Toolbox)

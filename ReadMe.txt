Encryption and decryption of text messages in digital images 
Anurag J Vaidya 
BMEG 220
4/22/2019

There are three MATLAB files:

1. Encryption.m : program to encrypt text messages in images
2. Decryption.m : program to decrypt encryted images 
3. DataAnalysis.m : program to do analysis on a set of pre-selected 12 sentences
 
Follow these steps to encrypt text messages:

1. Unzip the downloaded folder 
2. Initialize the MATLAB file named, "Encryption.m"
3. Enter the phrase you would like to encrypt.
	Note: Messages must be put in apostrophes ('')
	Note: Empty strings are not allowed. Maximum of 100 words allowed
4. Encrypted image is displayed and stored ('encryptedImage.bmp')
5. A decryption key ("word_map.mat") is stored in the working directory 
6. A table with statistics on the encryption is displayed. The table includes:
	1. Encryption time (seconds)
	2. Bits required for encryption if no compression algorithm used 
	3. Bits required for encryption if compression algorithm used 
	4. Number of pixels in the cover image changed 
	5. Percentage of total pixels changed (%)

Note: The program by default uses a regular puppy image as the cover image. Other 
sample images are provided in the folder. Following is a description of the sample images:
	1. "CoverImageSmall.bmp", "CoverImageMid.bmp", and "CoverImageLarge.bmp" are 
	three of the same image but of different sizes. For the "CoverImageSmall.bmp", the 
	maximum sentence length does not change
	2. "CoverImageWhite.bmp", "CoverImageNormal.bmp", and "CoverImageBlack.bmp" are three
	images of the same size, but with different color schemes 

Note: To change which cover image to use, change the name of the cover image in line 44 in "Encryption.m"

Note: Here are some sample input phrases:

1. Simple text message: ‘Hey! How are you?’
2. Message with special characters: ‘Meet me at these coordinates @ 40.9548N 76.8851W’  
3. Numerical message: ‘5704158931 893802 3940502’
4. Any phrase that you would like that meets the length and uniqueness requirements!
When a user inputs a message, the user must ensure to put the message in apostrophes, which is how MATLAB recognizes a string. 
Empty strings are not allowed. Maximum of 100 words allowed. 

Follow these steps to decrypt the message 

1. Run the program named, "Decryption.m"
2. The program will ouput the message stored in the image

Note: ensure that the files, "word_map.mat", "encryptedImage.bmp", and "decryption.m" are in the same folder.

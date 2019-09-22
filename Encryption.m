%% AJV 
% BMEG 220 Final Project
% 3/27/2019

%% This part is the driver for the encryption program

clear 
close all
clc

% set format
format shortG

% define global variables
global bits_changed

% get input string
s = input('Enter string in apostrophes ('' '') to be encrypted (100 words max): ');

% trim any leading or trailing whitespaces
s = strtrim(s);

% check if input string s is valid 
% checkUnique function will output error message if the input is not valid
if isempty(s) 
    error('Invalid input! Please enter a non-empty string')
elseif sum(double(s)==39)>=1
    error('Invalid expression apostrophe in input message')
else
    word_map = checkUnique(s);
    fprintf('Encryption in progress\n')
end

% Start timer for encryption
tic 

% convert string to numbers using word_map
s_comp = compress(word_map,s);

% get binary stream for s_comp (each number represented by 5 bits)
s_binary = str2binary(s_comp);

%load cover image and find image size and total pixels 
cover = imread('CoverImageNormal.bmp');
cover_size = size(cover);
total_pixels = cover_size(1)*cover_size(2);

% put binary stream in LSB of pixels
encrypted_image = encrypt(cover, s_binary);

% show encrypted image
image(encrypted_image)
axis off
title('Encrypted Image')

% save encrypted image
imwrite(encrypted_image, 'encryptedImage.bmp')

% add sentence length to word map to help decryption
str_cell = str2cell(s);
words = length(str_cell{1,1});
word_map('w') = strcat(num2str(words), '1');

% save word map for decryption 
save('word_map.mat', 'word_map')

% calculate bits saved
bitsSaved = howManyBitsSaved(s, s_binary);

% output encyrption statistics
output = cell([6,2]);
output{1,1} = 'Encryption Time (s)'; 
output{2,1} = 'Bits required if no compression algorithm used';
output{3,1} = 'Bits required if compression algorithm used';
output{4,1} = 'Bits saved by compression algorithm';
output{5,1} = 'Number of pixels in the cover image changed by encryption algorithm';
output{6,1} = 'Percentage of total pixels changed (%)';

output{1,2} = toc;
output{2,2} = bitsSaved(1);
output{3,2} = bitsSaved(2);
output{4,2} = abs(bitsSaved(1)-bitsSaved(2));
output{5,2} = bits_changed;
output{6,2} = 100*(bits_changed/total_pixels);

T = cell2table(output);
T.Properties.VariableNames = {'Criteria', 'Data'};
disp(T)

%% guide user to decryption 
fprintf('Your encrypted image is stored as encryptedImage.bmp \n')
fprintf('Go to the decryption algorithm (decryption.m) to decrypt the image\n')

%% functions 

function word_map = checkUnique(string)
% takes an input string 'string' and returns a word_map if there are less than 128 unique 
% words/ numbers otherwise outputs an error message  

    % convert string to a vector with each value being one word
    string_cell = str2cell(string);
    
    % initialize word_map
    word_map = containers.Map('KeyType','char','ValueType','char');
    
    % keep track of unique keys
    key_count = 0;
    
    % create map
    if length(string_cell{1,1})>100
        error('String exceeds maximum length of 100 words')
    else
        for i=1:length(string_cell{1,1})
            current_word = string_cell{1,1}{i};
            if ~isKey(word_map,current_word)
                key_count = key_count + 1;
                if key_count <= 9
                    special_key_count = strcat('0',num2str(key_count));
                    word_map(current_word) = special_key_count;
                else
                    word_map(current_word) = num2str(key_count);
                end
            end
        end
    end
end
    



function string_num = compress(word_map, string)
% takes in a string 'string' and key 'word_map' and returns a string of numbers 
% representing the string 

% to be returned string
string_num = ''; 

% strip string by spaces
string_cell = str2cell(string);

% find number equivalent of each word and add to string_num
for i=1:length(string_cell{1,1})
    current_key = string_cell{1,1}{i};
    current_value = word_map(current_key);
    string_num = strcat(string_num,num2str(current_value));
end
end


function binary_stream = str2binary(string)
% takes in a string of numbers and returns a vector that has binary
% equivalent of the string. Numbers are grouped by two's

% Initialize the array that will 
binary_stream = [];
i = 1;

while i <= (length(string) - 1)
    current_num_decimal = str2num(string(i:i+1));
    current_num_binary = getBinary(current_num_decimal);
    binary_stream = [binary_stream, current_num_binary];
    i = i + 2;
end

end

function encrypted_image = encrypt(cover,binary)
% take the binary stream and put it in the LSB of each pixel

% create new image
encrypted_image = cover;

% get image size
image_size = size(cover);
x = image_size(1);
y = image_size(2);
z = image_size(3);

% keep track of changed bits
global bits_changed 
bits_changed = 0;

% encryption
for row=1:x
   for col=1:y
      for height=1:z
         if isempty(binary)
         else
             current_bit = num2str(binary(1));
             current_pixel_decimal = encrypted_image(row, col, height);
             current_pixel_binary = dec2bin(current_pixel_decimal);
             current_pixel_binary(length(current_pixel_binary)) = current_bit;
             new_pixel_decimal = bin2dec(current_pixel_binary);
             encrypted_image(row,col,height) = new_pixel_decimal;
             binary = binary(2:end);
             
             if ~(cover(row, col, height) == encrypted_image(row, col, height))
                bits_changed = bits_changed + 1; 
             end
         end
 
      end
   end
    
end
end


function binary = getBinary(num)
% takes in a decimal number and returns a 7 bit binary representation of
% the number
binary = decimalToBinaryVector(num, 7, 'MSBFirst');
end

function bitsSaved = howManyBitsSaved(original_string,binary_stream)
% takes in original string and binary stream. Returns a vector bitsSaved
% which has the number of bits required if no compression algorithm used
% and number of bits required if compression algorithm used

% calculate number of bits required if compression algorithm used
compressed_bits = length(binary_stream);

% calculate number of bits required if no compression algorithm used
uncompressed_bits = 0;

for i=1:length(original_string)
   current_ascii = double(original_string(i));
   current_binary = getBinary(current_ascii);
   uncompressed_bits = uncompressed_bits + length(current_binary);
end

% updated bitsSaved vector
bitsSaved = [uncompressed_bits, compressed_bits];
end


function string_cell = str2cell(string)
%% takes an input string 'string' and returns a 1x1 cell 'string_cell' whose
% values are the words in the string
string_cell = textscan(string,'%s','Delimiter',' ');
end


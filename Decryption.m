%% AJV 
% BMEG 220 Final Project
% 3/27/2019
% Decryption Driver 

clear
close all
clc

% load encrypted image
encrypted = imread('encryptedImage.bmp');

% load word map
load('word_map.mat')

% get length of binary stream 
stream_length = getStreamLength();

% get binary stream 
binaryStream = getBinaryStream(encrypted,stream_length);

% get encrypted message in vector form
message = decrypt(binaryStream, word_map);

% remove any leading or trailing white spaces
message = strtrim(message);

% output 
fprintf('The encrypted message has been decypted\n')
disp(['The decrypted message is: ', '"' message, '"'])

%% functions

function streamLength = getStreamLength()
load('word_map.mat');
len = word_map('w');
len = len(1:end-1);
streamLength = 7*str2double(len);
end

function binaryStream = getBinaryStream(encrypted, stream_length)

binaryStream = [];
image_size = size(encrypted);
x = image_size(1);
y = image_size(2);
z = image_size(3);

for row=1:x
    for col=1:y
        for height=1:z
            if length(binaryStream) == stream_length
               break
            else
                current_pixel = dec2bin(encrypted(row,col,height));
                last_bit = current_pixel(length(current_pixel));
                binaryStream = [binaryStream, last_bit];
            end
            
        end
    end
end 
end

function message_vector = decrypt(binaryStream, word_map)
message_vector = [];

% reverse word_map
rev_map = containers.Map(values(word_map),keys(word_map));

while ~isempty(binaryStream)
    current_binary = binaryStream(1:7);
    current_decimal = bin2dec(current_binary);
    % add zero to beginning if needed 
    if current_decimal <=9
        current_decimal_str = strcat('0',num2str(current_decimal));
    else
        current_decimal_str = num2str(current_decimal);
    end
    current_word = rev_map(current_decimal_str);
    message_vector = [message_vector, ' ', current_word];
    binaryStream = binaryStream(8:end);
    
end
end



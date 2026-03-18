clc;
clear;
close all;

% Step 1: Define folders structure
inputFolder = 'input_images';
outputFolder = 'output_images';

if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Step 2: Get all image files
extensions = {'*.jpg','*.jpeg','*.png','*.bmp','*.tif'};
files = [];

for i = 1:length(extensions)
    files = [files; dir(fullfile(inputFolder, extensions{i}))];
end

if isempty(files)
    error('No image files found in input_images folder.');
end

% Step 3: Process each image one by one
for f = 1:length(files)
    % Read image
    fileName = files(f).name;
    filePath = fullfile(inputFolder, fileName);
    img = imread(filePath);

    % Convert RGB input image to grayscale
    gray = rgb2gray(img);

    % Noise reduction by applying median filter
    
    gFilt = imgaussfilt(gray,1);
    medFilt = medfilt2(gFilt, [3 3]);
    

    % Step 4: Detect circles by using Hough Transform
    [centers, radii, metric] = imfindcircles(medFilt, [37 500], ...     % [37 500] refering the size of the circle
        'ObjectPolarity', 'dark', ...
        'Sensitivity', 0.97, ...
        'EdgeThreshold', 0.05);

    if ~isempty(centers)

        % Keep strong detections
        keep = metric > 0.24;
        centers = centers(keep, :);
        radii   = radii(keep);
        metric  = metric(keep);

        % Remove overlapping circles
        n = size(centers,1);
        removeIdx = false(n,1);

        for i = 1:n
            for j = i+1:n
                d = norm(centers(i,:) - centers(j,:));

                if d < 0.6 * min(radii(i), radii(j))
                    if metric(i) >= metric(j)
                        removeIdx(j) = true;
                    else
                        removeIdx(i) = true;
                    end
                end
            end
        end

        centers = centers(~removeIdx,:);
        radii   = radii(~removeIdx);

        % Remove inner small circles
        n = size(centers,1);
        removeInner = false(n,1);

        for i = 1:n
            for j = 1:n
                if i ~= j
                    d = norm(centers(i,:) - centers(j,:));

                    if d + radii(i) < 0.9*radii(j) && radii(i) < 0.75*radii(j)
                        removeInner(i) = true;
                    end
                end
            end
        end

        centers = centers(~removeInner,:);
        radii   = radii(~removeInner);

        numCoins = size(centers,1);

    else
        numCoins = 0;
    end

    % Step 5: Print result
    fprintf('Image: %s --> Coins detected = %d\n', fileName, numCoins);

    % Step 6: Show AND save result
    figure;   % <-- THIS FIX SHOWS IMAGE
    imshow(img);
    hold on;

    if exist('centers','var') && ~isempty(centers)
        viscircles(centers, radii, 'Color', 'g');
    end

    title(['Coins = ', num2str(numCoins), ' (', fileName, ')']);
    hold off;

    % Save output
    saveas(gcf, fullfile(outputFolder, ['result_' fileName]));

    clear centers radii metric
end
% import the .mat files and convert them into one single mat file


% Get a list of all .mat files in the current directory, excluding data.mat
files = dir('*.mat');
files = files(~ismember({files.name}, 'data.mat'));

% Initialize an empty matrix to store the combined data
combined_data = [];

% Loop through each file and load its contents
for i = 1:length(files)
    filename = files(i).name;
    filedata = load(filename);
    
    % Extract the simpler_array structure from the file
    simpler_array = filedata.simpler_array;
    
    % Append the simpler_array data to the combined data matrix
    combined_data = [combined_data; simpler_array];
end

% Save the combined data directly to the data.mat file
save('data.mat', combined_data, '-ascii');
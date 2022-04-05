% work directory
cd 'C:\xampp\htdocs\perceivedAnimacy\stim'

% create last black frame in RGB (0,0,0) is black
black = repmat(0,[720 1152 3]);

% loop for chasing
for v = 1:300 
    reader = VideoReader(['chasing\trial' num2str(v) '.mp4']);
    writer = VideoWriter(['chasing2\trial' num2str(v) 'mod.mp4'], ...
        'MPEG-4');
    writer.FrameRate = reader.FrameRate;
    
    % open video
    open(writer);
    
    % loop of 120 frames plus 1 black frame
    for i = 1:121 
        if i < 121
            img = read(reader,i);
            writeVideo(writer,img);
        else
            writeVideo(writer,black);
        end
    end
    
    % close video
    close(writer);
end

% loop for mirror chasing
for v = 1:300 
    reader = VideoReader(['mirrorChasing\trial' num2str(v) '.mp4']);
    writer = VideoWriter(['mirrorChasing2\trial' num2str(v) 'mod.mp4'], ...
        'MPEG-4');
    writer.FrameRate = reader.FrameRate;
    
    % open video
    open(writer);
    
    % loop of 120 frames plus 1 black frame
    for i = 1:121 
        if i < 121
            img = read(reader,i);
            writeVideo(writer,img);
        else
            writeVideo(writer,black);
        end
    end
    
    % close video
    close(writer);
end





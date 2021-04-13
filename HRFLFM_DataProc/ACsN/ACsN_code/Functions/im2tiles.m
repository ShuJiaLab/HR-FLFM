function A = im2tiles(a,varargin)

Nx = 128;
Ny = 128;
Nz = size(a,3);
overlap = 0;

switch length(varargin)
    case 1
        overlap = varargin{1};
    case 2
        overlap = varargin{1};
        Nx = varargin{2};
        Ny = varargin{2};
    case 3
        overlap = varargin{1};
        Nx = varargin{2};
        Ny = varargin{3};
    case 4
        overlap = varargin{1};
        Nx = varargin{2};
        Ny = varargin{3};
        Nz = varargin{4};
end

overlap = max(0,round(overlap));

ny = floor(size(a,1)/Ny);
reminder_y = rem(size(a,1),Ny);
% if reminder_y < 64 && reminder_y > 0
%     warning('Warning: some images size is too small! Consider changing Ny');
% end

dimyDist = Ny*ones(1,ny);

if reminder_y
    if reminder_y<=overlap
        dimyDist(end) = dimyDist(end) + reminder_y;
    else
        dimyDist = cat(2,dimyDist,reminder_y);
    end
end

nx = floor(size(a,2)/Nx);
reminder_x = rem(size(a,2),Nx);

% if reminder_x < 64 && reminder_x > 0
%     warning('Warning: some images size is too small! Consider changing Nx');
% end

dimxDist = Nx*ones(1,nx);

if reminder_x
    if reminder_x<=overlap
        dimxDist(end) = dimxDist(end) + reminder_x;
    else
        dimxDist = cat(2,dimxDist,reminder_x);
    end
end

if overlap == 0
    if size(a,3)==1
        A = mat2cell(a,dimyDist,dimxDist);
    else
        nz = floor(size(a,3)/Nz);
        reminder_z = rem(size(a,3),Nz);
        dimzDist = Nz*ones(1,nz);
        
        if reminder_z
            dimzDist = cat(2,dimzDist,reminder_z);
        end
        
        A = mat2cell(a,dimyDist,dimxDist,dimzDist);
        
    end
    
else
    
    if size(a,3)==1
        
        sizey = length(dimyDist);
        sizex = length(dimxDist);
        
        A = cell(sizey,sizex);
        
        for i=1:sizey
            for j=1:sizex
                
                if i == 1
                    head_y = 1;
                else
                    head_y = 1 + (i-1)*dimyDist(i-1);
                end
                
                if j == 1
                    head_x = 1;
                else
                    head_x = 1 + (j-1)*dimxDist(j-1);
                end
                
                if i == sizey
                    tail_y = sum(dimyDist(1:i));
                else
                    tail_y = sum(dimyDist(1:i)) + overlap;
                end
                
                if j == sizex
                    tail_x = sum(dimxDist(1:j));
                else
                    tail_x = sum(dimxDist(1:j)) + overlap;
                end
                
                A{i,j} = a(head_y:tail_y,head_x:tail_x);
            end
        end
        
    else
        
        nz = floor(size(a,3)/Nz);
        reminder_z = rem(size(a,3),Nz);
        dimzDist = Nz*ones(1,nz);
        
        if reminder_z
            dimzDist = cat(2,dimzDist,reminder_z);
        end
        
        sizey = length(dimyDist);
        sizex = length(dimxDist);
        sizez = length(dimzDist);
        
        A = cell(sizey,sizex);
        
        for i=1:sizey
            for j=1:sizex
                for k=1:sizez
                    
                    if i == 1
                        head_y = 1;
                    else
                        head_y = 1 + (i-1)*dimyDist(i-1);
                    end
                    
                    if j == 1
                        head_x = 1;
                    else
                        head_x = 1 + (j-1)*dimxDist(j-1);
                    end
                    
                    if k == 1
                        head_z = 1;
                    else
                        head_z = 1 + (k-1)*dimzDist(k-1);
                    end
                    
                    if i == sizey
                        tail_y = sum(dimyDist(1:i));
                    else
                        tail_y = sum(dimyDist(1:i)) + overlap;
                    end
                    
                    if j == sizex
                        tail_x = sum(dimxDist(1:j));
                    else
                        tail_x = sum(dimxDist(1:j)) + overlap;
                    end
                    
                    tail_z = sum(dimzDist(1:k));
                    
                    
                    A{i,j,k} = a(head_y:tail_y,head_x:tail_x,head_z:tail_z);
                end
            end
        end
    end
end
end
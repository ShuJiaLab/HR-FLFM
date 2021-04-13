function output = tiles2im(input,varargin)

overlap = 0;

if length(varargin)==1
    overlap = varargin{1};
end

overlap = max(0,round(overlap));

if overlap == 0
    output = cell2mat(input);
else
    
    ncells = size(input);
    ncells(3) = size(input,3);
    
    
    for i = 1:ncells(1)
        Y(i) = size(input{i,1,1},1);
    end
    
    for i = 1:ncells(2)
        X(i) = size(input{1,i,1},2);
    end
    
    for i = 1:ncells(3)
        Z(i) = size(input{1,1,i},3);
    end
    
    szy = sum(Y) - overlap*(ncells(1)-1);
    szx = sum(X) - overlap*(ncells(2)-1);
    output = zeros(szy,szx,sum(Z));
    
    for i = 1:ncells(1)
        for j = 1:ncells(2)
            for k = 1:ncells(3)
                
                if i == 1
                    head_y = 1;
                    tail_y = Y(1);
                else
                    head_y = 1 + sum(Y(1:i-1))-overlap*(i-1);
                    tail_y = sum(Y(1:i))-overlap*(i-1);
                end
                
                if j == 1
                    head_x = 1;
                    tail_x = X(1);
                else
                    head_x = 1 + sum(X(1:j-1))-overlap*(j-1);
                    tail_x = sum(X(1:j))-overlap*(j-1);
                end
                
                if k == 1
                    head_z = 1;
                else
                    head_z = 1 + sum(Z(1:k-1));
                end
                
                %                 if i == ncells(1)
                %                     tail_y = sum(Y(1:i));
                %                 else
                %                     tail_y = sum(Y(1:i));
                %                 end
                %
                %                 if j == ncells(2)
                %                     tail_x = sum(X(1:j));
                %                 else
                %                     tail_x = sum(X(1:j));
                %                 end
                
                tail_z = sum(Z(1:k));
                
                a = input{i,j,k};
                
                % top left corner
                if i == 1 && j == 1
                    output(head_y:head_y+overlap-1,head_x:head_x+overlap-1,head_z:tail_z) = a(1:overlap,1:overlap,:);
                else
                    output(head_y:head_y+overlap-1,head_x:head_x+overlap-1,head_z:tail_z) = ...
                        (output(head_y:head_y+overlap-1,head_x:head_x+overlap-1,head_z:tail_z)+a(1:overlap,1:overlap,:))./2;
                end
                
                % overlap in y
                if i == 1
                    output(head_y:head_y+overlap-1,head_x+overlap:tail_x,head_z:tail_z) = a(1:overlap,1+overlap:end,:);
                else
                    output(head_y:head_y+overlap-1,head_x+overlap:tail_x,head_z:tail_z) = ...
                        (output(head_y:head_y+overlap-1,head_x+overlap:tail_x,head_z:tail_z)+a(1:overlap,1+overlap:end,:))./2;
                end
                
                % overlap in x
                if j == 1
                    output(head_y+overlap:tail_y,head_x:head_x+overlap-1,head_z:tail_z) = a(1+overlap:end,1:overlap,:);
                else
                    output(head_y+overlap:tail_y,head_x:head_x+overlap-1,head_z:tail_z) = ...
                        (output(head_y+overlap:tail_y,head_x:head_x+overlap-1,head_z:tail_z)+a(1+overlap:end,1:overlap,:))./2;
                end
                
                output(head_y+overlap:tail_y,head_x+overlap:tail_x,head_z:tail_z) = a(1+overlap:end,1+overlap:end,:);
                
            end
        end
    end
    
end

end

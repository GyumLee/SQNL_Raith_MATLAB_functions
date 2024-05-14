function meand_array = meander_sort(...
                                    array, ...
                                    options...
                                    )
    arguments
        array (:,2) double {mustBeNumeric}
        options.dir string {mustBeMember(options.dir,{'left','right'})} = 'right'
        options.plot logical = false
    end
    meand_array=NaN(size(array));
    dir_var = strcmp(options.dir, 'left');

    yvalues=unique(array(:,2),'sorted');
    
    for i=1:size(yvalues,1)
        ind = array(:,2) == yvalues(i);
        

        if mod(i + dir_var,2) == 1
            array_ys = sort(array(ind,:),'ascend');
        else
            array_ys = sort(array(ind,:),'descend');
        end

        nind = isnan(meand_array(:,1));
        start_ind = size(array,1)-sum(nind)+1;
        end_ind = start_ind + size(array_ys,1)-1;
        meand_array(start_ind:end_ind,:) = array_ys;
    end
    disp('check meander path by using option _plot_')

    if options.plot
        % if get(gcf,'Name') == 'meander_path'
        % 
        % end
        fig = gcf;
        if ~strcmp(fig.Name, 'Meander plot') %check figure name. if it is not meander plot, make new figure
            fig = figure('Name','Meander plot');
        end
        hold on
        plot(meand_array(:,1), meand_array(:,2),'o')
        dp_array = meand_array(2:end,:) - meand_array(1:end-1,:);
        quiver(meand_array(1:end-1,1), meand_array(1:end-1,2)...
            , dp_array(:,1), dp_array(:,2),'off','--')

        axis equal
        axis padded

        hold off
    end


end
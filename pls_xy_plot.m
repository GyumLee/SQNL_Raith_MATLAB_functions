function pls_xy_plot(args)
%it plot xy coordinamte of positionlist and show its order
    arguments
        args.pls Raith_positionlist
    end
    pls = args.pls;
    uv_c = [pls.poslist.uv_c];
    num_uv = size(uv_c,2); 
    % since the delimenator of uv_c is ',', the actual number of uv pair is
    % the half of num_uv.
    figure('Name','position_list_order')
    hold on
    plot(uv_c(1:2:num_uv),uv_c(2:2:num_uv),'-o')
    text(uv_c(1),uv_c(2),'start')
    text(uv_c(end-1),uv_c(end),'end')
    hold off
end
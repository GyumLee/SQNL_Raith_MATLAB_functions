function pls_xy_plot(args)
%it plot xy coordinamte of positionlist and show its order
    arguments
        args.pls Raith_positionlist
        args.order (1,1) logical = false
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
    if args.order
        for i = 1:num_uv/2
            text(uv_c(2*i-1)+0.01, uv_c(2*i), num2str(i))
        end
    end
    hold off
end
function mark_scan_struct ...
    = gen_mark_scan_element(mark_scan_properties,...
                            option_args)

    arguments
        mark_scan_properties.mark_scan_size (1,1) {double,mustBeNonnegative}
        mark_scan_properties.mark_positions (:,2) {double,mustBeNumeric}
        option_args.plot logical = false
    end

    mark_array_element = [Raith_element];

    for i = 1:size(mark_scan_properties.mark_positions,1)
        scan_rectangle_position = [mark_scan_properties.mark_positions(i, :) - mark_scan_properties.mark_scan_size/2;
        mark_scan_properties.mark_positions(i, :) + mark_scan_properties.mark_scan_size/2] ;
        % field name 'a' means nothing... it is just for not causing field
        % name error
    
        marks.(append('a', num2str(i))) = Raith_element;
        marks.(append('a', num2str(i))).type = 'polygon';
        marks.(append('a', num2str(i))).data.layer = 63;
        marks.(append('a', num2str(i))).data.uv = [scan_rectangle_position(1,1), scan_rectangle_position(2,1), scan_rectangle_position(2,1), scan_rectangle_position(1,1), scan_rectangle_position(1,1);
                                                scan_rectangle_position(1,2), scan_rectangle_position(1,2), scan_rectangle_position(2,2), scan_rectangle_position(2,2), scan_rectangle_position(1,2)];
        marks.(append('a', num2str(i))).data.DF = 1;
    
        mark_array_element(i) = marks.(append('a', num2str(i)));
    
    
    end
    mark_scan_struct = Raith_structure('Mark_scan',mark_array_element);
    disp('The name of structures is Mark_scan')

    if option_args.plot
        figure('Name',"plot: mark_scan areas")
        mark_scan_struct.plot
        axis equal
    end

end
function line_scan_struct = auto_mark_scan_struct(args)
    % This function creates a structure with line scans and check marks at the mark positions
    % The line scans are placed on layer 61 and check marks on layer 60
    % Ths linescans are placed on southwest of each marks and it will fail if stage error is larger than 1/4 of the mark size
    arguments
        args.mark_size (1,1) double {mustBeNonnegative} = 100
        args.mark_positions (:,2) double {mustBeNumeric}
        args.line_scan_length (1,1) double  = NaN % if NaN, it will be set to mark_size
        args.line_scan_width (1,1) double = 2
        args.check_width (1,1) double = 1
        args.check_length (1,1) double = 5
        args.plot logical = false
    end
    mark_size = args.mark_size;
    mark_positions = args.mark_positions;
    num_marks = size(mark_positions,1);
    line_scan_length = args.line_scan_length;
    line_scan_width = args.line_scan_width;
    scan_offset = mark_size/4; % offset from the mark position, a quarter of the mark size
    if isnan(line_scan_length)
        line_scan_length = mark_size;
    end
    check_width = args.check_width;
    check_length = args.check_length;

    line_array_element = [Raith_element];

   
    for i = 1:num_marks
        lines.(append('x', num2str(i))) = Raith_element;
        lines.(append('x', num2str(i))).type = 'path';
        lines.(append('x', num2str(i))).data.layer = 61;
        lines.(append('x', num2str(i))).data.uv = [mark_positions(i,1) - line_scan_length/2, mark_positions(i,1) + line_scan_length/2;
                                                mark_positions(i,2) - scan_offset, mark_positions(i,2) - scan_offset];
        lines.(append('x', num2str(i))).data.w = line_scan_width;
        lines.(append('x', num2str(i))).data.DF = 1;

        lines.(append('y', num2str(i))) = Raith_element;
        lines.(append('y', num2str(i))).type = 'path';
        lines.(append('y', num2str(i))).data.layer = 61;
        lines.(append('y', num2str(i))).data.uv = [mark_positions(i,1) + scan_offset, mark_positions(i,1) + scan_offset;
                                                mark_positions(i,2) - line_scan_length/2, mark_positions(i,2) + line_scan_length/2];
        lines.(append('y', num2str(i))).data.w = line_scan_width;
        lines.(append('y', num2str(i))).data.DF = 1;

        lines.(append('check', num2str(i))) = Raith_element;
        lines.(append('check', num2str(i))).type = 'polygon';
        lines.(append('check', num2str(i))).data.layer = 60;
        lines.(append('check', num2str(i))).data.uv = [-check_length/2, -check_width/2, -check_width/2, check_width/2, check_width/2, check_length/2, check_length/2, check_width/2, check_width/2, -check_width/2, -check_width/2, -check_length/2;
                                                        -check_width/2, -check_width/2, -check_length/2, -check_length/2, -check_width/2, -check_width/2, check_width/2, check_width/2, check_length/2, check_length/2, check_width/2, check_width/2]...
                                                        + mark_positions(i,:)';
        lines.(append('check', num2str(i))).data.DF = 1;

        line_array_element(3*i-2) = lines.(append('y', num2str(i)));
        line_array_element(3*i-1) = lines.(append('x', num2str(i)));
        line_array_element(3*i) = lines.(append('check', num2str(i)));
        
    end

    line_scan_struct = Raith_structure('Line_scan',line_array_element);
    disp('The name of structures is Line_scan')
    
    if args.plot
        figure('Name',"plot: line_scan areas")
        line_scan_struct.plot
        axis equal
    end

end
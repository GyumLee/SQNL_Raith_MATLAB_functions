function pls_construction(args)
% Positionlist should exist before run this code.
% Be careful about order. pls will be organized by first come first scan
% manner
    arguments
    args.pls Raith_positionlist
    args.mark_positions (:,2) double
    args.mark_offset (1,2) double = [0,0] % % This is correction for when align key is mislocated 
    args.scan_positions (:,2) double
    args.wfield_size (1,1) double
    args.mark_layer (1,:) double = [60, 63] %63 for manual markscan and 61 for automatic scan, % layer 60 for check marks
    args.scan_layer (1,:) double
    args.num_jj (1,1) double = 1
    args.rot_angle (1,1) double = 90
    args.rind (1,:) double = NaN(1)
    args.array_name char = 'Junction_array'
    end
    pls = args.pls;
    mark_positions = args.mark_positions;
    scan_positions = args.scan_positions;
    mark_offset = args.mark_offset;
    wfield_size = args.wfield_size;
    mark_layer = args.mark_layer;
    scan_layer = args.scan_layer;
    num_jj = args.num_jj;
    rot_angle = args.rot_angle;
    rind = args.rind;
    array_name = args.array_name;

    num_scan = size(scan_positions,1);
    rot_mat = [cos(rot_angle/180*pi) sin(rot_angle/180*pi); -sin(rot_angle/180*pi) cos(rot_angle/180*pi)];
    is_same_pos = prod(abs(mark_positions(1,:)) > wfield_size);
    

    for i= 1:num_scan
        remd = mod(i,num_jj)==0; % 0 remainder conversion
        ii = mod(i,num_jj) + num_jj*remd; % index for checking rind
        if sum(ii == rind) == 1  % case when ind match with rind
            mark_scan_positon = scan_positions(i,:) +  is_same_pos * mark_positions(1,:)*rot_mat + mark_offset;
            %if wfield is smaller than mark_position, mark scan will be done at
            %mark position. otherwise, mark_scan_position is the same with scan_position
            pls.append(array_name, ...
                mark_scan_positon*1e-3, ...
                1, ...
                [mark_scan_positon mark_scan_positon] + 0.5 * [-1 -1 1 1]*wfield_size, ...
                mark_layer)
            pls.append(array_name, ...
                scan_positions(i,:)*1e-3, ...
                1, ...
                [scan_positions(i,:) scan_positions(i,:)] + 0.5 * [-1 -1 1 1]*wfield_size, ...
                scan_layer)
        else
            mark_scan_positon = scan_positions(i,:) +  is_same_pos * mark_positions(1,:) + mark_offset;
            pls.append(array_name, ...
                mark_scan_positon*1e-3, ...
                1, ...
                [mark_scan_positon mark_scan_positon] + 0.5 * [-1 -1 1 1]*wfield_size, ...
                mark_layer)
            pls.append(array_name, ...
                scan_positions(i,:)*1e-3, ...
                1, ...
                [scan_positions(i,:) scan_positions(i,:)] + 0.5 * [-1 -1 1 1]*wfield_size, ...
                scan_layer)
        end
        
     end


end
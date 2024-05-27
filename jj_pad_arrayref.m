function element_array = jj_pad_arrayref(array_args)
% Make array of jj and pads
% If you set rotation angle and indices, it will rotate every ith element
% Before run this array ref, you should run 'gen_junction_element()' and
% 'gen_mark_scan_element()'
    arguments
        array_args.chip_position_jj (:,2) {mustBeNumeric}
        array_args.jj_size  double
        array_args.num_jjs_per_chip (1,1) double = 1
        array_args.rot  (1,1) double = 90
        array_args.rind (1,:) double = NaN(1)
        array_args.line_scan_offset (1,2) double = [0,0] % This is correction for when align key is mislocated 
        array_args.manual logical = true
    end

    element_array = [Raith_element]; % element array preallocation
    
    pos_jj = array_args.chip_position_jj;
    jj_size = num2str(array_args.jj_size);
    num_jj = array_args.num_jjs_per_chip;
    num_pos = size(array_args.chip_position_jj,1);
    rot_ang = array_args.rot;
    rind = array_args.rind;
    line_scan_offset = array_args.line_scan_offset;

    if array_args.manual
        for i=1:num_pos
            remd = mod(i,num_jj)==0; % 0 remainder conversion
            ii = mod(i,num_jj) + num_jj*remd; % index for checking rind
            if sum(ii == rind) == 1 % case when ind match with rind
                element_array(4*i-3)=Raith_element('sref','Mark_scan',[pos_jj(i,:)], 1, rot_ang, 0);
                element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                element_array(4*i-1)=Raith_element('sref','lpad',[pos_jj(i,:)], 1, rot_ang, 0);
                element_array(4*i)=Raith_element('sref','rpad',[pos_jj(i,:)], 1, rot_ang, 0);
            else
                element_array(4*i-3)=Raith_element('sref','Mark_scan',[pos_jj(i,:)], 1, 0, 0);
                element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,0,0);
                element_array(4*i-1)=Raith_element('sref','lpad',[pos_jj(i,:)], 1, 0, 0);
                element_array(4*i)=Raith_element('sref','rpad',[pos_jj(i,:)], 1, 0, 0);
            end
        end
    else
        for i=1:num_pos
            remd = mod(i,num_jj)==0; % 0 remainder conversion
            ii = mod(i,num_jj) + num_jj*remd; % index for checking rind
            if sum(ii == rind) == 1 % case when ind match with rind
                element_array(4*i-3)=Raith_element('sref','Line_scan',[pos_jj(i,:)]+line_scan_offset, 1, rot_ang, 0);
                element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                element_array(4*i-1)=Raith_element('sref','lpad',[pos_jj(i,:)], 1, rot_ang, 0);
                element_array(4*i)=Raith_element('sref','rpad',[pos_jj(i,:)], 1, rot_ang, 0);
            else
                element_array(4*i-3)=Raith_element('sref','Line_scan',[pos_jj(i,:)]+line_scan_offset, 1, 0, 0);
                element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,0,0);
                element_array(4*i-1)=Raith_element('sref','lpad',[pos_jj(i,:)], 1, 0, 0);
                element_array(4*i)=Raith_element('sref','rpad',[pos_jj(i,:)], 1, 0, 0);
            end
        end   
    end

end
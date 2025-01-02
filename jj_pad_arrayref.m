function element_array = jj_pad_arrayref(array_args)
% Make array of jj and pads
% If you set rotation angle and indices, it will rotate every ith element
% Before run this array ref, you should run 'gen_junction_element()' and
% 'gen_mark_scan_element()'
    arguments
        array_args.chip_position_jj (:,2) {mustBeNumeric}
        array_args.jj_size  double
        array_args.num_jjs_per_chip (1,1) double = 1  % Number of jjs per chip. If you want to make different size of jj, Do not use this. it will give identical jjs
        array_args.rot  (1,1) double = 90     % Rotation angle in degree
        array_args.rind (1,:) double = NaN(1) % Index of jj and pad to rotate. if you want to rotate 3rd and 4th jj, set rind = [3,4]
        array_args.line_scan_offset (1,2) double = [0,0] % This is correction for when align key is mislocated 
        array_args.manual logical = true    % If you want to make manual markscan, set true
        array_args.pixel_write logical = false  % If you want to make pixel write jj, set true and adjust dose time.
        array_args.prefix char = '' % Prefix for jj and pad. It usually used for test jj and pad
    end

    element_array = [Raith_element]; % element array preallocation
    
    pos_jj = array_args.chip_position_jj;
    jj_size = num2str(array_args.jj_size);
    num_jj = array_args.num_jjs_per_chip;
    num_pos = size(array_args.chip_position_jj,1);
    rot_ang = array_args.rot;
    rind = array_args.rind;
    line_scan_offset = array_args.line_scan_offset;
    pixel_write = array_args.pixel_write;
    prefix = array_args.prefix;
    if pixel_write
        Jwire_name = append(prefix,'Jwire','_pixel');
    else
        Jwire_name = append(prefix,'Jwire',jj_size);
    end
    lpad_name = append(prefix,'lpad');
    rpad_name = append(prefix,'rpad');


    if array_args.manual
        for i=1:num_pos
            remd = mod(i,num_jj)==0; % 0 remainder conversion
            ii = mod(i,num_jj) + num_jj*remd; % index for checking rind
            if sum(ii == rind) == 1 % case when ind match with rind
                element_array(4*i-3)=Raith_element('sref','Mark_scan',[pos_jj(i,:)], 1, rot_ang, 0);
                if pixel_write
                    element_array(4*i-2)=Raith_element('sref',Jwire_name,[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                else
                    element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                end
                element_array(4*i-1)=Raith_element('sref',lpad_name,[pos_jj(i,:)], 1, rot_ang, 0);
                element_array(4*i)=Raith_element('sref',rpad_name,[pos_jj(i,:)], 1, rot_ang, 0);
            else
                element_array(4*i-3)=Raith_element('sref','Mark_scan',[pos_jj(i,:)], 1, 0, 0);
                if pixel_write
                    element_array(4*i-2)=Raith_element('sref',Jwire_name,[pos_jj(i,:)],1,0,0); % To make Jwire direction same, set reflection 1
                else
                    element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,0,0); % To make Jwire direction same, set reflection 1
                end
                element_array(4*i-1)=Raith_element('sref',lpad_name,[pos_jj(i,:)], 1, 0, 0);
                element_array(4*i)=Raith_element('sref',rpad_name,[pos_jj(i,:)], 1, 0, 0);
            end
        end
    else
        for i=1:num_pos
            remd = mod(i,num_jj)==0; % 0 remainder conversion
            ii = mod(i,num_jj) + num_jj*remd; % index for checking rind
            if sum(ii == rind) == 1 % case when ind match with rind
                element_array(4*i-3)=Raith_element('sref','Line_scan',[pos_jj(i,:)]+line_scan_offset, 1, rot_ang, 0);
                if pixel_write
                    element_array(4*i-2)=Raith_element('sref',Jwire_name,[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                else
                    element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,rot_ang,1); % To make Jwire direction same, set reflection 1
                end
                element_array(4*i-1)=Raith_element('sref',lpad_name,[pos_jj(i,:)], 1, rot_ang, 0);
                element_array(4*i)=Raith_element('sref',rpad_name,[pos_jj(i,:)], 1, rot_ang, 0);
            else
                element_array(4*i-3)=Raith_element('sref','Line_scan',[pos_jj(i,:)]+line_scan_offset, 1, 0, 0);
                if pixel_write
                    element_array(4*i-2)=Raith_element('sref',Jwire_name,[pos_jj(i,:)],1,0,0); % To make Jwire direction same, set reflection 1
                else
                    element_array(4*i-2)=Raith_element('sref',append('Jwire',jj_size),[pos_jj(i,:)],1,0,0);
                end
                element_array(4*i-1)=Raith_element('sref',lpad_name,[pos_jj(i,:)], 1, 0, 0);
                element_array(4*i)=Raith_element('sref',rpad_name,[pos_jj(i,:)], 1, 0, 0);
            end
        end   
    end

end
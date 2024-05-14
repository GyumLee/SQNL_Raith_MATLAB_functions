function element_array = electrod_arrayref(args)
    arguments
        args.chip_position_elec (:,2) {mustBeNumeric}
        args.num_elecs_per_chip (1,1) double = 1
        args.rot  (1,1) double = 90
        args.rind (1,:) double = NaN(1)
    end
    
    element_array = [Raith_element]; % element array preallocation

    pos = args.chip_position_elec;
    num_pos = size(args.chip_position_elec,1);
    num_elec = args.num_elecs_per_chip;
    rot_ang = args.rot;
    rind = args.rind;

    for i=1:num_pos
        remd = mod(i,num_pos)==0; % 0 remainder conversion
        ii = mod(i,num_pos) + num_elec*remd; % index for checking rind
        if sum(ii == rind) == 1 % case when ind match with rind
            element_array(2*i-1)=Raith_element('sref','electrode',[pos(i,:)], 1, rot_ang, 0);
            element_array(2*i)=Raith_element('sref','electrode',[pos(i,:)], 1, rot_ang, 0);
        else
            element_array(2*i-1)=Raith_element('sref','electrode',[pos(i,:)], 1, 0, 0);
            element_array(2*i)=Raith_element('sref','electrode',[pos(i,:)], 1, 0, 0);
        end
    end

end
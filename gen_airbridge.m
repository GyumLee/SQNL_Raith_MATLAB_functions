function [air_bridge_struct, refstruct_array] = gen_airbridge(args)
    arguments
        args.length (1,1) double {mustBeNumeric} = 40
        args.width (1,1) double {mustBeNumeric} = 5
        args.angle (1,1) double {mustBeNumeric} = 0
        args.contact_size (1,2) double {mustBeNumeric} = [10, 10]
        args.longdose_length (1,1) double {mustBeNumeric} = 5
        args.transdose_length (1,1) double {mustBeNumeric} = 5
        args.longdose_high (1,1) double {mustBeNumeric} = 1
        args.longdose_low (1,1) double {mustBeNumeric} = 0.1
        args.longdose_nsteps (1,1) double {mustBeNumeric} = 10
        args.transdose_high (1,1) double {mustBeNumeric} = 0.5
        args.transdose_low (1,1) double {mustBeNumeric} = 0.2
        args.transdose_nsteps (1,1) double {mustBeNumeric} = 3
        args.layer (1,1) double {mustBeNumeric} = 3

    end
    length = args.length; % length of air bridge except contact pads
    width = args.width; % width of air bridge
    contact_size = args.contact_size; % size of contact pads
    longdose_length = args.longdose_length; % length of longitudinal dose
    transdose_length = args.transdose_length; % length of transverse dose
    longdose_high = args.longdose_high; % high dose of longitudinal dose
    longdose_low = args.longdose_low; % low dose of longitudinal dose
    longdose_nsteps = args.longdose_nsteps; % number of steps of longitudinal dose
    transdose_high = args.transdose_high; % high dose of transverse dose
    transdose_low = args.transdose_low; % low dose of transverse dose
    transdose_nsteps = args.transdose_nsteps; % number of steps of transverse dose
    layer = args.layer; % layer of air bridge

    % contact pad points
    % each of them are hexagon which combined results is a rectangle
    % Reference is designed for left contact pad
    % Actual pads will be placed sref method with exact position and fliping
    contact_pad1_points = [-contact_size(1)/2, contact_size(1)*0.4, contact_size(1)/5, contact_size(1)/5, contact_size(1) * 0.4, -contact_size(1)/2, -contact_size(1)/2;
                            -contact_size(2)/2, -contact_size(2)/2, -width/2, width/2,contact_size(2)/2, contact_size(2)/2, -contact_size(2)/2];
    contact_pad2_points = [contact_size(1)*0.4, contact_size(1)/2, contact_size(1)/2, contact_size(1)*0.4, contact_size(1)/5, contact_size(1)/5, contact_size(1)*0.4;
                             -contact_size(2)/2, -contact_size(2)/2, contact_size(2)/2, contact_size(2)/2, width/2, -width/2, -contact_size(2)/2];

    contact_pad(1) = Raith_element;
    contact_pad(1).type = 'polygon';
    contact_pad(1).data.layer = layer;
    contact_pad(1).data.uv = contact_pad1_points;
    contact_pad(1).data.DF = longdose_high;
    contact_pad(2) = Raith_element;
    contact_pad(2).type = 'polygon';
    contact_pad(2).data.layer = layer;
    contact_pad(2).data.uv = contact_pad2_points;
    contact_pad(2).data.DF = longdose_high*0.9;
    
    % contact_pad_struct = Raith_structure('contact_pad', [contact_pad1, contact_pad2]);
    contact_pad_struct = Raith_structure(append('contact_pad_',num2str(length)), contact_pad);

    contact_pad_left = Raith_element('sref',append('contact_pad_',num2str(length)),[-length/2-contact_size(1)/2,0],1,0,0);
    contact_pad_right = Raith_element('sref',append('contact_pad_',num2str(length)),[length/2+contact_size(1)/2,0],1,180,0);


    % ramp points
    % Reference is designed for left ramp
    % Actual ramp will be placed sref method with exact position and fliping
    ramp_points_part = [-longdose_length/2, longdose_length/2, longdose_length/2, -longdose_length/2, -longdose_length/2;
                    -width/2, -width/2, width/2, width/2, -width/2];
    long_ramp = [Raith_element];
    for i = 1:longdose_nsteps-2
        long_ramp(i) = Raith_element;
        long_ramp(i).type = 'polygon';
        long_ramp(i).data.layer = layer;
        long_ramp(i).data.uv = [ramp_points_part(1,:)/(longdose_nsteps-2);ramp_points_part(2,:)] + ...
                                            [longdose_length*((1+2*(i-1))/2/(longdose_nsteps-2)-0.5);0];
        long_ramp(i).data.DF = longdose_high - (longdose_high - longdose_low)/(longdose_nsteps-1)*(i+1);
    end

    long_ramp_struct = Raith_structure(append('long_ramp_',num2str(length)),long_ramp);

    long_ramp_left = Raith_element('sref',append('long_ramp_',num2str(length)),[-length/2+longdose_length/2,0],1,0,0);
    long_ramp_right = Raith_element('sref',append('long_ramp_',num2str(length)),[length/2-longdose_length/2,0],1,180,0);

    % sidecut points
    % Reference is designed for lower sidecut
    % Actual sidecut_ramp will be placed sref method with exact position and fliping
    sidecut_points = [-length/2+longdose_length, length/2 - longdose_length, length/2 - longdose_length, -length/2+longdose_length, -length/2+longdose_length;
                        -transdose_length/2, -transdose_length/2, transdose_length/2, transdose_length/2, -transdose_length/2];
    sidecut_ramp = [Raith_element];
    for i = 1:transdose_nsteps
        sidecut_ramp(i) = Raith_element;
        sidecut_ramp(i).type = 'polygon';
        sidecut_ramp(i).data.layer = layer;
        sidecut_ramp(i).data.uv = [sidecut_points(1,:);sidecut_points(2,:)/transdose_nsteps] + ...
                                            [0; transdose_length*(-(1+2*(i-1))/2/(transdose_nsteps)+0.5)];
        sidecut_ramp(i).data.DF = transdose_high - (transdose_high - transdose_low)/(transdose_nsteps-1)*(i-1);
    end

    sidecut_ramp_struct = Raith_structure(append('sidecut_ramp_',num2str(length)),sidecut_ramp);
    sidecut_ramp_bottom = Raith_element('sref',append('sidecut_ramp_',num2str(length)),[0,-width/2-transdose_length/2],1,0,0);
    sidecut_ramp_top = Raith_element('sref',append('sidecut_ramp_',num2str(length)),[0,width/2+transdose_length/2],1,180,0);

    air_bridge_struct = Raith_structure(append('air_bridge_',num2str(length)),[contact_pad_left, contact_pad_right, ...
                                                long_ramp_left, long_ramp_right, ...
                                                sidecut_ramp_bottom, sidecut_ramp_top]);
    refstruct_array = [contact_pad_struct, long_ramp_struct, sidecut_ramp_struct];

    
end

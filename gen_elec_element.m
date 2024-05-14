function elec_struct = gen_elec_element(args)
    arguments
        args.elec_dia (1,1) double {mustBeNumeric}
        args.arm_length (1,1) double {mustBeNumeric}
        args.arm_width (1,1) double {mustBeNumeric}
        args.num_circle (1,1) double {mustBeNumeric} = 72
        args.layer (1,1) double {mustBeNumeric} = 1
        args.plot logical = false
    end
    elec_dia = args.elec_dia;
    arm_length = args.arm_length;
    arm_width = args.arm_width;
    num_circle = args.num_circle;
    layer = args.layer;

    theta = 0:2*pi/num_circle:2*pi; % theta for circle
    theta = theta(theta>asin(arm_width/elec_dia)==1); % remove theta which is out of arm length
    theta = theta(2*pi-theta>asin(arm_width/elec_dia)==1); % remove theta which is out of arm length
    elec_points = elec_dia / 2 * [cos(theta); sin(theta)]; % circle points
    arm_points = [elec_dia/2 * cos(asin(arm_width/elec_dia)), arm_length, arm_length, elec_dia/2 * cos(asin(arm_width/elec_dia));
                    -arm_width/2, -arm_width/2, arm_width/2, arm_width/2]; % arm points
    start_point = [elec_dia/2 * cos(asin(arm_width/elec_dia)); arm_width/2];
    elec_points = [start_point, elec_points, arm_points]; % combine circle and arm points

    electrode = Raith_element;
    electrode.type = 'polygon';
    electrode.data.layer = layer;
    electrode.data.uv = elec_points;
    electrode.data.DF = 1;

    elec_struct = Raith_structure('electrode', electrode);

    if args.plot
        figure('Name','plot: electrode')
        elec_struct.plot
        axis equal
    end
end
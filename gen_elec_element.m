function elec_struct = gen_elec_element(args)
    arguments
        args.elec_dia (1,1) double {mustBeNumeric} = 2
        args.arm_length (1,1) double {mustBeNumeric} = 25
        args.arm_width (1,1) double {mustBeNumeric} = 1
        args.num_circle (1,1) double {mustBeNumeric} = 72
        args.layer (1,1) double {mustBeNumeric} = 1
        args.etch (1,1) logical = false
        args.etch_overlap (1,1) double {mustBeNumeric} = 3
        args.gap (1,1) double {mustBeNumeric} = 2
        args.cut_length_left (1,1) double {mustBeNumeric} = 25
        args.cut_length_right (1,1) double {mustBeNumeric} = 15
        args.arm_widewidth (1,1) double {mustBeNumeric} = 6
        args.plot logical = false
    end
    elec_dia = args.elec_dia;
    arm_length = args.arm_length;
    arm_width = args.arm_width;
    num_circle = args.num_circle;
    layer = args.layer;
    etch_overlap = args.etch_overlap;
    gap = args.gap;
    cut_length_left = args.cut_length_left;
    cut_length_right = args.cut_length_right;
    arm_widewidth = args.arm_widewidth;


    theta = 0:2*pi/num_circle:2*pi; % theta for circle
    theta = theta((theta>=asin(arm_width/elec_dia))==1); % remove theta which is out of arm length
    theta = theta((2*pi-theta>=asin(arm_width/elec_dia))==1); % remove theta which is out of arm length
    
    if ~args.etch
        elec_points = elec_dia / 2 * [cos(theta); sin(theta)]; % circle points
        arm_points = [elec_dia/2 * cos(asin(arm_width/elec_dia)), arm_length, arm_length, elec_dia/2 * cos(asin(arm_width/elec_dia));
                        -arm_width/2, -arm_width/2, arm_width/2, arm_width/2]; % arm points
        start_point = [elec_dia/2 * cos(asin(arm_width/elec_dia)); arm_width/2];
        elec_points = [start_point, elec_points, arm_points]; % combine circle and arm points
    else
        % start point
        start_point = [cut_length_right; arm_width/2];
        %upper points before circle
        upper_points_before_circle = [arm_length, arm_length, cut_length_right, cut_length_right, (elec_dia+gap)/2*cos(asin((arm_width+ gap)/(elec_dia+gap)));
                                        arm_widewidth/2 + etch_overlap/2 ,arm_widewidth/2+etch_overlap, arm_widewidth/2+etch_overlap, (arm_width+ gap)/2, (elec_dia+gap)/2*sin(asin((arm_width+ gap)/(elec_dia+gap)))];
        %upper circle points
        utheta = theta((pi-theta>=asin((arm_width+ gap)/(elec_dia+gap)))==1);
        utheta = utheta((utheta>=asin((arm_width+ gap)/(elec_dia+gap)))==1);
        upper_circle_points = (elec_dia+gap) / 2 * [cos(utheta); sin(utheta)];
        %outer points between circle
        outer_points =[-(elec_dia+gap)/2 * cos(asin((arm_width+ gap)/(elec_dia+gap))),-cut_length_left-etch_overlap, -cut_length_left-etch_overlap, -(elec_dia+gap)/2 * cos(asin((arm_width+ gap)/(elec_dia+gap)));
                        (elec_dia+gap)/2 * sin(asin((arm_width+ gap)/(elec_dia+gap))), (arm_width+ gap)/2, -(arm_width+ gap)/2, -(elec_dia+gap)/2 * sin(asin((arm_width+ gap)/(elec_dia+gap)))];
        %lower circle point
        ltheta = theta((theta-pi>=asin((arm_width+ gap)/(elec_dia+gap)))==1);
        ltheta = ltheta((2*pi-ltheta>=asin((arm_width+ gap)/(elec_dia+gap)))==1);
        lower_circle_points = (elec_dia+gap) / 2 * [cos(ltheta); sin(ltheta)];
        %lower points after circle
        lower_points_after_circle = [(elec_dia+gap)/2 * cos(asin((arm_width+ gap)/(elec_dia+gap))), cut_length_right, cut_length_right, arm_length, arm_length, cut_length_right;
                                        -(elec_dia+gap)/2 * sin(asin((arm_width+ gap)/(elec_dia+gap))), -(arm_width+gap)/2, -arm_widewidth/2- etch_overlap, -arm_widewidth/2- etch_overlap, -arm_widewidth/2 - etch_overlap/2, -arm_width/2];
        %inner circle points -- this is almost same as not etch case
        intheta = flip(theta);
        inner_circle_points = elec_dia / 2 * [cos(intheta); sin(intheta)];
        point_before_inner_circle = [elec_dia/2 * cos(asin(arm_width/elec_dia)); -arm_width/2];
        point_after_inner_circle = [elec_dia/2 * cos(asin(arm_width/elec_dia)); arm_width/2];
        inner_circle_points = [point_before_inner_circle, inner_circle_points, point_after_inner_circle];
        %combine all points
        elec_points = [start_point, upper_points_before_circle, upper_circle_points, outer_points, lower_circle_points, lower_points_after_circle, inner_circle_points];
    end




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
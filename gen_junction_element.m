function [Jwire_struct, lstrip_struct, rstrip_struct, lpad_struct, rpad_struct]...
    = gen_junction_element(...
                        pad_args, ...
                        junction_args, ...
                        wfield_args, ...
                        option_args...
                            )
    arguments
        pad_args.pad_width (1,1) {double,mustBeNonnegative}
        pad_args.pad_height (1,1) {double,mustBeNonnegative}
        pad_args.pad_gap (1,1) {double,mustBeNonnegative}
        pad_args.overlap (1,1) {double,mustBeNonnegative} = 10
        junction_args.Jwire_width (1,1) {double,mustBeNonnegative} = 0.2
        junction_args.Jwire_length (1,1) {double,mustBeNonnegative} = 2
        junction_args.wire_width (1,1) {double,mustBeNonnegative} = 2
        junction_args.Joverlap (1,1) {double,mustBeNonnegative} = 2
        wfield_args.wfield_jj (1,1) {double,mustBeNonnegative}
        wfield_args.wfield_pad (1,1) {double,mustBeNonnegative}
        option_args.plotedges logical = false
        option_args.plot logical = false
    end

    junction_center=[0 0]; % DO NOT CHANGE, FIX TO (0,0)
    position_offset=junction_center-[pad_args.pad_width+pad_args.pad_gap/2 pad_args.pad_height/2];

    % This is for the case when wfield is large enough to cover the gap
    % between pads.
    % It prevents strips on both side of the cross get too large length.
    if wfield_args.wfield_jj > 2 * pad_args.overlap + pad_args.pad_gap
        wfield_args.wfield_jj = 2 * pad_args.overlap + pad_args.pad_gap;
        extra_strip_message = true;
    else
        extra_strip_message = false;
    end
    Jwire_name = append('Jwire', num2str(junction_args.Jwire_width * 1e3));

    % Position define
        % JunctionPosition define
    clstrip_points=[pad_args.pad_width+pad_args.pad_gap/2-wfield_args.wfield_jj/2,pad_args.pad_height/2-junction_args.wire_width/2;...
                 pad_args.pad_width+pad_args.pad_gap/2*0.8,pad_args.pad_height/2-junction_args.wire_width/2;...
                 pad_args.pad_width+pad_args.pad_gap/2-junction_args.Jwire_length,pad_args.pad_height/2-junction_args.Jwire_width/2;...
                 pad_args.pad_width+pad_args.pad_gap/2-junction_args.Jwire_length,pad_args.pad_height/2+junction_args.Jwire_width/2;...
                 pad_args.pad_width+pad_args.pad_gap/2*0.8,pad_args.pad_height/2+junction_args.wire_width/2;...
                 pad_args.pad_width+pad_args.pad_gap/2-wfield_args.wfield_jj/2,pad_args.pad_height/2+junction_args.wire_width/2]...
                 + position_offset;
                 
    crstrip_points=[pad_args.pad_width+pad_args.pad_gap/2-junction_args.Jwire_width/2,pad_args.pad_height/2+junction_args.Jwire_length;...
                 pad_args.pad_width+pad_args.pad_gap/2+junction_args.Jwire_width/2,pad_args.pad_height/2+junction_args.Jwire_length;...
                 pad_args.pad_width+pad_args.pad_gap/2+junction_args.wire_width/2,pad_args.pad_height/2+pad_args.pad_gap/2*0.2;...
                 pad_args.pad_width+pad_args.pad_gap/2+wfield_args.wfield_jj/2,pad_args.pad_height/2+pad_args.pad_gap/2*0.2;...
                 pad_args.pad_width+pad_args.pad_gap/2+wfield_args.wfield_jj/2,pad_args.pad_height/2+pad_args.pad_gap/2*0.2+junction_args.wire_width;...
                 pad_args.pad_width+pad_args.pad_gap/2-junction_args.wire_width/2,pad_args.pad_height/2+pad_args.pad_gap/2*0.2+junction_args.wire_width;...
                 pad_args.pad_width+pad_args.pad_gap/2-junction_args.wire_width/2,pad_args.pad_height/2+pad_args.pad_gap/2*0.2]...
                 +position_offset;
                 
    lstrip_points=[pad_args.pad_width-pad_args.overlap,pad_args.pad_height/2-junction_args.wire_width/2;...
                           pad_args.pad_width+pad_args.pad_gap/2-wfield_args.wfield_jj/2+junction_args.Joverlap,pad_args.pad_height/2+junction_args.wire_width/2]...
                           +position_offset;
    rstrip_points=[pad_args.pad_width+pad_args.pad_gap/2+wfield_args.wfield_jj/2-junction_args.Joverlap,pad_args.pad_height/2+pad_args.pad_gap/2*0.2;...
                           pad_args.pad_width+pad_args.pad_gap+pad_args.overlap,pad_args.pad_height/2+pad_args.pad_gap/2*0.2+junction_args.wire_width]...
                           +position_offset;
    
    Jwire1_points=[pad_args.pad_width+pad_args.pad_gap/2-junction_args.Jwire_length-junction_args.Joverlap, pad_args.pad_height/2-junction_args.Jwire_width/2 ;...
                            pad_args.pad_width+pad_args.pad_gap/2+junction_args.Jwire_width/2+3, pad_args.pad_height/2+junction_args.Jwire_width/2]...
                            +position_offset;
     
    Jwire2_points=[pad_args.pad_width+pad_args.pad_gap/2-junction_args.Jwire_width/2, pad_args.pad_height/2-junction_args.Jwire_width/2-3;...
                           pad_args.pad_width+pad_args.pad_gap/2+junction_args.Jwire_width/2, pad_args.pad_height/2+junction_args.Jwire_length+junction_args.Joverlap]...
                           +position_offset;

        %Pad position define
    lpad_points=[0,0; pad_args.pad_width, 0; pad_args.pad_width, pad_args.pad_height; 0, pad_args.pad_height; 0,0]+position_offset;
    rpad_points=[pad_args.pad_gap+pad_args.pad_width,0; pad_args.pad_gap+2*pad_args.pad_width, 0; pad_args.pad_gap+2*pad_args.pad_width,pad_args.pad_height; pad_args.pad_gap+pad_args.pad_width,pad_args.pad_height; pad_args.pad_gap+pad_args.pad_width,0]...
    +position_offset;

    % Raith_element define - Junction wire
    Jwire1=Raith_element;
    Jwire1.type='polygon';
    Jwire1.data.layer=1;
    Jwire1.data.uv=[Jwire1_points(1,1) Jwire1_points(2,1) Jwire1_points(2,1) Jwire1_points(1,1) Jwire1_points(1,1);...
        Jwire1_points(1,2) Jwire1_points(1,2) Jwire1_points(2,2) Jwire1_points(2,2) Jwire1_points(1,2)];
    Jwire1.data.DF=1;
    
    Jwire2=Raith_element;
    Jwire2.type='polygon';
    Jwire2.data.layer=1;
    Jwire2.data.uv=[Jwire2_points(1,1) Jwire2_points(2,1) Jwire2_points(2,1) Jwire2_points(1,1) Jwire2_points(1,1);...
        Jwire2_points(1,2) Jwire2_points(1,2) Jwire2_points(2,2) Jwire2_points(2,2) Jwire2_points(1,2)];
    Jwire2.data.DF=1;
    
    clstrip=Raith_element;
    clstrip.type='polygon';
    clstrip.data.layer=1;
    clstrip.data.uv=[clstrip_points(:,1)' clstrip_points(1,1);...
        clstrip_points(:,2)' clstrip_points(1,2)];
    clstrip.data.DF=1;
    
    crstrip=Raith_element;
    crstrip.type='polygon';
    crstrip.data.layer=1;
    crstrip.data.uv=[crstrip_points(:,1)' crstrip_points(1,1);...
        crstrip_points(:,2)' crstrip_points(1,2)];
    crstrip.data.DF=1;
      
    lstrip=Raith_element;
    lstrip.type='polygon';
    lstrip.data.layer=2;
    lstrip.data.uv=[lstrip_points(1,1) lstrip_points(2,1) lstrip_points(2,1) lstrip_points(1,1) lstrip_points(1,1);...
        lstrip_points(1,2) lstrip_points(1,2) lstrip_points(2,2) lstrip_points(2,2) lstrip_points(1,2)];
    lstrip.data.DF=1;
    
    rstrip=Raith_element;
    rstrip.type='polygon';
    rstrip.data.layer=3;
    rstrip.data.uv=[rstrip_points(1,1) rstrip_points(2,1) rstrip_points(2,1) rstrip_points(1,1) rstrip_points(1,1);...
        rstrip_points(1,2) rstrip_points(1,2) rstrip_points(2,2) rstrip_points(2,2) rstrip_points(1,2)];
    rstrip.data.DF=1;

    % Raith_element define - Junction pad
    lpad=Raith_element;
    lpad.type='polygon';
    lpad.data.layer=0;
    lpad.data.uv=[lpad_points(:,1)'; lpad_points(:,2)'];
    lpad.data.DF=1;
    
    rpad=Raith_element;
    rpad.type='polygon';
    rpad.data.layer=0;
    rpad.data.uv=[rpad_points(:,1)'; rpad_points(:,2)'];
    rpad.data.DF=1;
    
    % Raith_struct define
    Jwire_struct=Raith_structure(Jwire_name, [Jwire1, Jwire2 clstrip crstrip]);
    lstrip_struct=Raith_structure('lstrip',lstrip);
    rstrip_struct=Raith_structure('rstrip',rstrip);
    lpad_struct=Raith_structure('lpad', lpad);
    rpad_struct=Raith_structure('rpad', rpad);

    if extra_strip_message
        disp("wfield_jj is large enought to cover the gap between pads.")
        disp("Do not have to use lstrip_struct and rstrip struct.")
        disp(" ")
    end
    disp("The name of structures are " + Jwire_name + " , lstrip, rstrip, lpad, and rpad")

    struct_array = [Jwire_struct, lstrip_struct, rstrip_struct, lpad_struct, rpad_struct];
    

    % plotting sturctures
    if option_args.plotedges
        Junction_lib=Raith_library('temporal_library', struct_array);
        disp('junction zoom-in')
        figure('Name',"plotedges zoom-in: Junction"+num2str(junction_args.Jwire_width*1e3))
        for i = Junction_lib.structlist
            Junction_lib.plotedges(i)
        end
        axis(1.2*[-junction_args.Jwire_length junction_args.Jwire_length -junction_args.Jwire_length junction_args.Jwire_length])
        axis equal
    end

    if option_args.plot
        Junction_lib=Raith_library('temporal_library', struct_array);

        figure('Name',"plot: Junction"+num2str(junction_args.Jwire_width*1e3))
        for i = Junction_lib.structlist
            Junction_lib.plot(i)
        end
        axis equal
    end

end
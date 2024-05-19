function uv_array = uv_array_creation(args)
    arguments
        args.ustart (1,1) double = 0
        args.unum (1,1) double = 9
        args.upitch (1,1) double = 10000
        args.vstart (1,1) double = 0
        args.vnum (1,1) double = 9
        args.vpitch (1,1) double = 10000
    end
    ustart = args.ustart;
    unum = args.unum;
    upitch = args.upitch;
    vstart = args.vstart;
    vnum = args.vnum;
    vpitch = args.vpitch;

   

    uv_array = zeros(unum * vnum,2);
    for i1 = 1:unum
        for i2 = 1:vnum
            uv_array((i1-1)*vnum + i2,1) = ustart + (i1-1)*upitch;
            uv_array((i1-1)*vnum + i2,2) = vstart + (i2-1)*vpitch;
        end
    end



end

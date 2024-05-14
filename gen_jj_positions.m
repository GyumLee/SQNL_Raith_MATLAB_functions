function jj_positions = gen_jj_positions(junction_args, chip_args)
% Generate absolute positions of jjs on each chip position
% Function do not recognize neither rotation nor reflection
% If you want to rotate or reflect structure, use jj_pad_arrayref
    arguments
        junction_args.jj_positions (:,2) double {mustBeNumeric}
        chip_args.chip_positions (:,2) double {mustBeNumeric}
    end

    jj_positions_local = junction_args.jj_positions;
    chip_positions = chip_args.chip_positions;
    num_jj = size(jj_positions_local,1);
    
    jj_positions = kron(chip_positions, ones(num_jj,1));
    for i=1:size(jj_positions,1)
        remd = mod(i,num_jj)==0; % 0 remainder conversion
        jj_positions(fix(i/num_jj) * num_jj...
            + mod(i,num_jj),:)...
            = jj_positions(i,:) + jj_positions_local(num_jj*(remd)+mod(i,num_jj),:);
    end

end
%% table creation
% create table for each type
all_bmis_data = table;

%% files
% fill with appropriate directory
files = dir("C:\Users\Joanne Jo\OneDrive - University of Waterloo\AllDataFinal_20230822\Blocked Force Data [COMPLETE]" + ...
    "\ALL DATA\bmis\BMIS 2");

%% code

% iterate through files to get file names
% need to precheck list to see start and stop index
for i = 4:length(files)
    filename = files(i).name;
    
    idx = strfind(filename, '_');

    ss_name = filename(1:idx(1)-1);
    if strcmp(ss_name, 'SR') == 1
        ss_name = 'Latex Sheet';
    elseif strcmp(ss_name, 'BMIS') == 1
        ss_name = 'BMIS Rolled';
    elseif strcmp(ss_name, 'RS') == 1
        ss_name = 'Rolled Ripstop';
    elseif strcmp(ss_name, 'LTube') == 1
        ss_name = 'Latex Tube';
    elseif strcmp(ss_name, 'Dip') == 1
        ss_name = 'Latex Dip';
    end

    ss_thickness = filename(idx(1)+1:idx(2)-1);
    if strcmp(ss_name, 'Latex Dip') == 1
        ss_thickness = str2num(ss_thickness);
    elseif strcmp(ss_name, 'BMIS Rolled') == 1
        if strcmp(ss_thickness, '01') == 1
            ss_thickness = 0.1/25.4;
        elseif strcmp(ss_thickness, '02') == 1
            ss_thickness = 0.2/25.4;
        end
    elseif strcmp(ss_thickness, '01') == 1
        ss_thickness = 0.01;
    elseif strcmp(ss_thickness, '02') == 1
        ss_thickness = 0.02;
    elseif strcmp(ss_thickness, '012') == 1
        ss_thickness = 0.012;
    elseif strcmp(ss_thickness, '006') == 1
        ss_thickness = 0.006; 
    elseif strcmp(ss_thickness, '1') == 1
        ss_thickness = 0.00551;
    elseif strcmp(ss_thickness, '2') == 1
        ss_thickness = 0.011020;
    elseif strcmp(ss_thickness, '1-16') == 1
        ss_thickness = 1/16.0;
    elseif strcmp(ss_thickness, '1-32') == 1
        ss_thickness = 1/32.0;
    end

    ss_length = str2num(filename(idx(3)+1:end-4));
    ss_diameter = filename(idx(2)+1:idx(3)-1);

    if strcmp(ss_diameter, '1-16') == 1
        ss_diameter = 0.0625;
    elseif strcmp(ss_diameter, '2-16') == 1
        ss_diameter = 0.125;
    elseif strcmp(ss_diameter, '3-16') == 1
        ss_diameter = 0.1875;
    elseif strcmp(ss_diameter, '4-16') == 1
        ss_diameter = 0.25;
    end

    T = readtable(filename);
    temp = table;
    temp.Pressure = T.Var2;
    temp.Length = repmat(ss_length,length(T.Var2),1);
    temp.Diameter = repmat(ss_diameter, length(T.Var2),1);
    temp.Thickness = repmat(ss_thickness, length(T.Var2),1);
    temp.FabricationMethod = repmat(ss_name, length(T.Var2),1);
    temp.Force = T.Var3;

    all_bmis_data = [all_bmis_data;temp];

end

%% write to excel
writetable(all_bmis_data,'all_bmis_data.xlsx')
writetable(all_sr_data, 'all_sr_data.xlsx')
writetable(all_dip_data, 'all_dip_data.xlsx')
writetable(all_ripstop_data, 'all_ripstop_data.xlsx')
writetable(all_latextube_data, 'all_latextube_data.xlsx')
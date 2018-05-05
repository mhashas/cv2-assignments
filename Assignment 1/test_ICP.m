%% test section
% source = load('./Data/source.mat');
% target = load('./Data/target.mat');
% source = source.source;
% target = target.target;
[source, source_n] = getPcdMATfile("./data_mat1/0000000015");
[target, target_n] = getPcdMATfile("./data_mat1/0000000020");
source = source';
source_n = source_n';
target = target';
target_n = target_n';

%%
%for noiseto = ["one" "both"]
noiseto = "both";
for noise_removal = [0]%1]
    sampling.noise_removal = noise_removal;
    for sampling_name = [ "random" "random per iteration" "informative"] % "all"
        for noise_type = [ "none" ] %"gaussian small"  "gaussian big" "sa lt and pepper"]
            for repeat_experiment = 1:3
                if noise_type == "gaussian small"
                    noise = "gaussian";
                    sigma = "small";
                elseif noise_type == "gaussian big"
                    noise = "gaussian";
                    sigma = "big";
                else
                    noise = noise_type;
                    sigma = "_";
                end

                sampling.name = sampling_name;
                %set at 10%
                sampling.size = floor(size(source,2) / 10);

                if sampling.name == "informative"
                    sampling.normals = struct();
                    sampling.normals.source = source_n;
                    sampling.normals.target = target_n;
                end

                source_noise = add_noise(source, noise, sigma);
                if noiseto == "one"
                    target_noise = target;
                else
                    target_noise = add_noise(target, noise, sigma);
                end

                start_t = datetime('now');

                [R, t, rms_history] = ICP(source_noise, target_noise, 20, sampling, 0, 0);
                end_t = datetime('now');
                duration = end_t - start_t;

                %draw_source = R * source + t;
                %fscatter3(target(1, :), target(2, :), target(3, :), target(3, :));
                %fscatter3(draw_source(1, :), draw_source(2, :), draw_source(3, :), draw_source(3, :));
                str = sprintf("sampling:%s_noise:%s_noiseto:%s_noiseremoval:%d_experiment:%d", sampling.name,  noise, noiseto, noise_removal, repeat_experiment);
                fprintf("RMS: %4.4f %s \n",rms_history(length(rms_history)), str);
    %             hold all
    %             figure
    %             plot3(target(1, :), target(2, :), target(3, :), 'b.', 'markerSize', 0.3);
    %             plot3(draw_source(1, :), draw_source(2, :), draw_source(3, :), 'r.', 'markerSize', 0.3);
    %             title(str);
    %             close all
    %             save fig
                save(strcat("./experiments_human_15_20/",str,".mat"),'duration','rms_history','R', 't');
            end
        end
    end
end
%end
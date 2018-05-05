%% test section
% source = load('./Data/source.mat');
% target = load('./Data/target.mat');
% source = source.source;
% target = target.target;
source = struct
target = struct
[source.points, source.normals] = getPcdMATfile("./data_mat1/0000000015");
[target.points, target.normals] = getPcdMATfile("./data_mat1/0000000020");

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
                options.sampling = struct;
                options.sampling.name = sampling_name;
                %set at 10%
                options.sampling.value = floor(size(source,2) / 10);

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
                
                options.sampling.bothFrames = 0;    
                options.sampling.randomPerIteration = 1;
                options.sampling.isProcent = 0; % can merge isProcent and value fields in just one 'value' field
                options.sampling.noiseRemoval = noise_removal;

                options.rejectMatches = 1;
                options.visualiseSteps = 1;

                options.stoppingCriterion = struct;
                options.stoppingCriterion.epsilon = 0;
                options.stoppingCriterion.noIterations = 40;
                
                start_t = datetime('now');

                [R, t, rms_history] = ICP(source_noise, target_noise, options);
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
                %save(strcat("./experiments_human_15_20/",str,".mat"),'duration','rms_history','R', 't');
            end
        end
    end
end
%end
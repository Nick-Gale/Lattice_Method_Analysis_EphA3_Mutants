%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Load all necessary functions
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
addpath('functions_activity/')
addpath('functions_lattice_method/')
addpath('functions_plotting/')
addpath('functions_retinal_simulations/')
addpath("functions_analysis/")
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Define experiment set to parallel push through the Hjorth et al (2015) pipeline
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%

%% set the parameters that need to be passed to all workers in the parallel pool as global

global n_neurones n_iterations
n_neurones = 2000;
n_iterations = n_neurones ^ 2 * 5;

global gradients ratios beta2 repeats sz L
tel = 1.0;
knock_in = (-tel:(tel - (-tel))/10:tel) + tel;
gradients = 2.0; [0 knock_in];
ratios = 0.5; % [0.4, 0.5, 0.6];
beta2 = 0.00625; % [0.00625, 0.00625 * 5, 0.00625 * 10];%[0, 1];
repeats = 1:1;

% create the iteration object
sz = [length(gradients), length(ratios), length(beta2), length(repeats)];
L = prod(sz);
  
% create the gradient files
for ind = 1:L
        % set the indexes and the subsequent parameters
        [u, s, t, rep] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        b2_truth = beta2(t);

        %call out to gradient .csv and modify
        T = readtable('functions_retinal_simulations/gradients/Eph-ephrins-both-axis-JH.csv');
        T{5, 8} = grad;
        T{5, 15} = rat;
        gradient_file = sprintf('results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_beta2truth=%d.csv', n_neurones, grad, rat, b2_truth);
        writetable(T, gradient_file);
end

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Pipe through a parallel cluster
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%

%% create the pool, be nice about system resources
if isempty(gcp('nocreate'))
    parpool('local', 14);
end

%change into the directory of the Hjorth pipeline
cd('functions_retinal_simulations')
counter = 0;
tic
for ind = 1:L
        [u, s, t, rep] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        b2_truth = beta2(t);

        bact = 1 / (0.05 * 4320);
        gamma = b2_truth;
        chemical_scale = 1;
        alpha = 90; % 90%19 * chemical_scale;
        beta = 135; % 135%28.5 * chemical_scale;
            
        %copy the base experimental file
        file_name = sprintf('../results_experiments/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_beta2truth=%d.txt', n_neurones, grad, rat, b2_truth);
        copyfile('../results_experiments/WillshawGale_owens_base.txt', file_name)

        %modify the gradient file
        gradient_file = sprintf('../results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_beta2truth=%d.csv', n_neurones, grad, rat, b2_truth);
        
        %modify the key experimental parameters
        fileID = fopen(file_name, 'a+');
        fprintf(fileID, [sprintf('obj.gradientInfoFile = %s', ''''), gradient_file, sprintf('%s\n', '''')]);
        fprintf(fileID, 'obj.nSC = %d;, \n', n_neurones);
        fprintf(fileID, 'obj.nRGC = %d;, \n', n_neurones); 
        fprintf(fileID, 'obj.nSteps = %d;, \n', n_iterations); 
        fprintf(fileID, 'obj.alphaForwardChem = %f;, \n', alpha); 
        fprintf(fileID, 'obj.betaForwardChem = %f;, \n', beta);
        fprintf(fileID, 'obj.alphaReverseChem = 0;;, \n'); 
        fprintf(fileID, 'obj.betaReverseChem = 0;, \n');
        fprintf(fileID, 'obj.gammaAct = %f;, \n', gamma);
        
        %set the save targets
        fprintf(fileID, 'obj.reportStep = %f, \n', n_iterations + 1);
        fprintf(fileID, [sprintf('obj.simName = %s', ''''), sprintf('WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_beta2=%d_repeat=%d', n_neurones, n_iterations, grad, rat, b2_truth, rep), sprintf('%s \n', '''')]);
        fprintf(fileID, [sprintf('obj.dataPath = %s', ''''), '../results_experiments', sprintf('%s \n', '''')]);
        fprintf(fileID, [sprintf('obj.dataPath = %s', ''''), '../results_experiments', sprintf('%s \n', '''')]);

        fclose(fileID);
        %run
        
        %run the computation
        if ~isfile(sprintf('../results_experiments/WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_beta2=%d_repeat=%d.mat', n_neurones, n_iterations, grad, rat, b2_truth, rep))
                tic
                obj = RetinalMap(file_name);
                initializeRandomGenerator(obj)
                obj.run()
                disp([u, s, t, rep])
                toc
        else
                % disp("This experiment was already completed.")
                % disp(ind2sub(sz, ind))
        end
end
toc

%change back into the route directory
cd('../')

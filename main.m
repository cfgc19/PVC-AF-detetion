clear all
close all
LIST_AF={...
    'afdb_file-04043_episode-1'
    'afdb_file-04043_episode-2'
    'afdb_file-04043_episode-3'
    'afdb_file-04043_episode-4'
    'afdb_file-04048_episode-1'
    'afdb_file-04048_episode-2'
    'afdb_file-04048_episode-3'
    'afdb_file-04746_episode-1'
    'afdb_file-04746_episode-2'
    'afdb_file-04746_episode-3'
    'afdb_file-05261_episode-1'
    'afdb_file-05261_episode-2'
    'afdb_file-05261_episode-3'
    'afdb_file-05261_episode-4'
    'afdb_file-08219_episode-1'
    'afdb_file-08219_episode-2'
    'afdb_file-08219_episode-3'
    'afdb_file-08219_episode-4'
    };

LIST_PVC={...
    'DPVC_116', 'DPVC_201', 'DPVC_221', 'DPVC_233', ... 
    'DPVC_119', 'DPVC_203', 'DPVC_223', 'DPVC_106', ...
    'DPVC_200', 'DPVC_210', 'DPVC_228' };



fprintf('***********************AF CLASSIFICATION************************\n')

for list=1:length(LIST_AF)
    fs=125;
    clear DAT
    cmd=['load ' char(LIST_AF(list)) ];
    eval(cmd);
    ecg = DAT.ecg;
    true_output=DAT.class;
    [picos,values] = detect_R(DAT.ecg,fs);
    numbers_points = 875;
    
    time = length(ecg)/fs;
    [first_output] = AF_Functions.AF_detection_by_irregular_RR(numbers_points, ecg, picos, 13);
    [second_output] = AF_Functions.AF_detection_by_absence_P_waves(DAT.ecg,picos,numbers_points, 0.55);
    
    windows_true = AF_Functions.classification_true_output_by_windows(numbers_points,true_output);
    [sensibility1, spec1] = classification(first_output,windows_true);
    [sensibility2, spec2] = classification(second_output,windows_true);
    fprintf('=======================================\n')
    fprintf('Pacient: %s \n-----> Método AF 1 : Sensibility: %2.3f Specificity: %2.3f     Beats: %d   Heartbeats: %.2f beats/min \n', char(LIST_AF(list)), sensibility1, spec1, length(picos), length(picos)/time*60)
    fprintf('-----> Método AF 2 : Sensibility: %2.3f Specificity: %2.3f     Duration: %.0f seconds \n', sensibility2, spec2, time)
    fprintf('-------------------------------------------\n')
end


fprintf('\n***********************PVC CLASSIFICATION************************\n')

for i=1:length(LIST_PVC)
    fs=250;
    clear DAT
    cmd=['load ' char(LIST_PVC(i)) ];
    eval(cmd);
    picos = DAT.ind;
    time = length(DAT.ecg)/fs;
    fprintf('=======================================\n')
    output_1 = PVC_Functions.area_method(DAT,0.6);
    output_2 = PVC_Functions.distances_method(DAT,fs);
    [sensibility1, spec1] = classification(output_1, DAT.pvc);
    [sensibility2, spec2] = classification(output_2,DAT.pvc(1:length(output_2))');
    
    fprintf('Pacient: %s \n-----> Método PVC 1 : Sensibility: %2.3f Specificity: %2.3f     Beats: %d    Heartbeats: %.2f beats/min \n', char(LIST_PVC(i)), sensibility1, spec1, length(picos), length(picos)/time*60)
    fprintf('-----> Método PVC 2 : Sensibility: %2.3f Specificity: %2.3f     Duration: %.0f seconds \n', sensibility2, spec2, time)
end

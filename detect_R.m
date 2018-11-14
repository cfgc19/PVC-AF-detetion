function [picos,values] = detect_R(ECG, fs)

    order = 4;
    wc_1 = 20;

    fc = wc_1 / (0.5 * fs);
    [b, a] = butter(order, fc);
    e11 = filtfilt(b,a,ECG);

    wc_2 = 5;
    fc_2 = wc_2 / (0.5 * fs);
    [b_2,a_2] = butter(order, fc_2,'High');
    e22 = filtfilt(b_2,a_2,e11);


    e33 = diff(e22);
    e44= e33.^2;
    timeWindow = 0.2;

    N = fix(timeWindow*fs);
    b_5 = (1/N)*ones(1,N);
    a_5 = 1;
    e55 = filtfilt(b_5,a_5,e44);


    threshold = 0.1 * mean (e55);
    x = e55>threshold;
    y= diff(x);


    %%
    r=find(y==1);
    r1 = find(y==-1);

    picos = [];
    values=[];
    for i=1:length(r)-1
        if(r(i)<r1(i))
            matriz = e55(r(i):r1(i));
            [M,I] = max(matriz);
            index= I+r(i);
        else
            matriz = e55(r1(i):r(i));
            [M,I] = max(matriz);
            index= I+r1(i);
        end
        values =[values, M];
        picos=[picos, index];
    end
    
    time = length(ECG)/fs;
    heartbeats = length(picos)/time*60;
    
    
    %fprintf('\nBeats : %f \n', length(picos))
    %fprintf('Duration : %f \n', time)
    %fprintf('Heart Beats : %f \n', heartbeats)
    %fprintf('=======================================\n')
    
    %figure,
    %plot(ECG)
    %hold on
    %plot(picos, values, 'or')
    %hold off
end


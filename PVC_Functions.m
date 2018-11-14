classdef PVC_Functions
        methods(Static)
            function [output] = area_method(DAT, threshold)
                distances =[];
                for i=1:length(DAT.ind)
                    if DAT.ind(i)<50 % esta condição é só porque há pvcs com indice menor que 50
                        [min_left, min_index_1] = min(DAT.ecg(1:DAT.ind(i)));
                        min_index_left = 1+ min_index_1 - 1;
                    else
                    [min_left, min_index_1] = min(DAT.ecg(DAT.ind(i)-50:DAT.ind(i)));
                    min_index_left = DAT.ind(i) - 50+ min_index_1 - 1;
                    end
                    if (length(DAT.ecg)-DAT.ind(i))<50
                        [min_right, min_index_2] = min(DAT.ecg(DAT.ind(i):length(DAT.ecg)));
                        min_index_right = DAT.ind(i)+ min_index_2 - 1;
                    else
                    [min_right, min_index_2] = min(DAT.ecg(DAT.ind(i):DAT.ind(i)+50));
                    min_index_right = DAT.ind(i)+ min_index_2 - 1;
                    end
                    dist =min_index_right-min_index_left;
                    distances=[distances, dist];
                    %plot(DAT.ecg(DAT.ind(i)-50:DAT.ind(i)+50))
                    %hold on
                end
                output=[];
                for l=1:length(distances)
                    if (distances(l)>threshold*max(distances))
                        output=[output, 1];

                    else
                        output=[output, 0];
                    end
                end

            end
            
            function values = distances_method(DAT, fs)
                new_peaks_ind = DAT.ind';
                % 'Metodo das distancias'
                distance_between_vecs = length(DAT.ind) - length(new_peaks_ind);
                values = [];

                std_final = [];
                distance_between_peaks = diff(new_peaks_ind);

                matrix_extrap_2 = zeros(1,length(DAT.ind));
                test = [];


                margin_2 = 10;


                for ii = 1 : length(new_peaks_ind)-1  

                    for jj = ii : ii + distance_between_vecs

                        x = abs(new_peaks_ind(ii) - DAT.ind(jj));

                        if x < margin_2

                            matrix_extrap_2(jj) = distance_between_peaks(ii);

                            break

                        end

                    end
                end

                N = fs*10; %janelas de 10 segundos = 1250 pontos
                ind = 1;
                medias = [];


                for i = N:N:length(DAT.ecg)-N  

                    current   = find(new_peaks_ind < i);
                    current_2 = current(1,[ind:length(current)]);

                    current_distance_matrix = distance_between_peaks(current_2);
                    mean_dist = mean(current_distance_matrix(current_distance_matrix>0));

                    medias = [medias mean_dist];

                    std_dev = std(current_distance_matrix(current_distance_matrix>0));
                    std_final = [std_final std_dev];


                    if(std_dev >= 45)
                        for(j = 1:length(current_distance_matrix))

                            if(current_distance_matrix(j)>  mean_dist + std_dev/4)
                                values = [values 1];
                            else
                                values = [values 0];
                            end
                        end
                    else
                         for( j = 1:length(current_distance_matrix))
                             values = [values 0];
                         end

                    end

                    ind = length(current)+1;   

                end


                classification(values,DAT.pvc(1:length(values))');

            %     figure;title(char(list(k)));
            %     title(char(list(k)))
            %     plot(ecg)
            %     hold on
            %     plot(DAT.ind, ecg(DAT.ind),'x')
            %     hold on
            %     plot(new_peaks_ind(find(values==1)), ecg(find(values==1)),'o')
            %     hold off
            %     pause 

            end
    end             
end

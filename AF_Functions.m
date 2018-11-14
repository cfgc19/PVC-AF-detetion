
classdef AF_Functions
        methods(Static)
        function output = AF_detection_by_irregular_RR(points_number, ...
                data, picos, threshold)
            % 1º maneira de detetar AF: através do desvio padrao - distancia
            % irregular dos RR
            diff_pics=diff(picos);
            number=1;
            desvio_padrao=[];
            for y=points_number:points_number:length(data)-points_number
                if(length(find(picos<y))==0)
                     desvio_padrao = [desvio_padrao, 0];
                     number = 1;
                     % havia um caso que o sinal nao tinha nenhum pico
                     % antes dos 875 pontos. Por isso demos o valor de 0 ao
                     % desvio padrao
                else
                    % ele guarda o desvio padrao das diferenças dos picos
                    % que encontra naquela janela
                    desvio_padrao = [desvio_padrao, ...
                        std(diff_pics(number:length(find(picos<y))))];
                    number = length(find(picos<y));
                end
            end

            output=[];
            
            % se o valor do desvio padrao for superior ao nosso threshold é
            % considerado AF
            for i=1:length(desvio_padrao)
                if(desvio_padrao(i)>threshold)
                    output=[output,1];
                else
                    output=[output,0];
                end
            end

            %figure,
            %plot(desvio_padrao,'or')
            %xlabel('Número de janelas','FontSize',16,'FontWeight','bold')
            %ylabel('Valores do desvio de padrão','FontSize',16,'FontWeight','bold')

        end

        function [output] = AF_detection_by_absence_P_waves(data, picos, ...
                numbers_points, threshold)
            % 3º maneira. ver a ausencia dos picos P
            output=[];
            means_P_waves=[];

            number=1;
             for i=numbers_points:numbers_points:length(data)
                 P_waves=[];
                 for y=number:length(find(picos<i))
                     if picos(y)<70
                         matriz_falta = zeros(51-(picos(y)-20),1);
                         P_waves =[P_waves; vertcat(matriz_falta, ...
                             data(1:picos(y)-20))'];
                         % esta condição existe só porque o as vezes o
                         % primeiro pico é inferior a 50 pontos, logo nao
                         % podemos anteceder 50 pontos antes para encontrar
                         % a onda P.
                     else
                         % a onda P normalmente encontra-se entre os 50
                         % pontos e 10 pontos antes do pico R
                         P_waves =[P_waves; data(picos(y)-70:picos(y)-20)'];
                     end
                 end
                 mean_Pwaves = mean(P_waves);
                 distances_waves = abs(max(mean_Pwaves)-min(mean_Pwaves));
                 means_P_waves = [means_P_waves, distances_waves];
                 number = length(find(picos<i));
                 if length(find(picos<i)) == 0
                     number = 1;
                 end
             end

            for i=1:length(means_P_waves)
               if (means_P_waves(i)>threshold*max(means_P_waves))
                   output=[output, 0];
               else
                   output=[output, 1];
               end
            end
        end

        function windows_true = classification_true_output_by_windows...
                (points_number, true_output)

            %transformar o classificador do prof em janelas de true ou false 
            %relativamente a estar a ter ou nao AF  e depois comparar com o 
            %nosso atraves da funcao classificacao

            windows_true = [];
            number = 1;
            for i=points_number:points_number:length(true_output)

                if(isempty(find(true_output(number:i),1)))
                    windows_true = [windows_true, 0];
                else
                    windows_true = [windows_true, 1];
                end
                number=i;
            end
        end
    end
end

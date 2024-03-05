clear all;
close all;
clc;

% Inizializzazione webcam
wl = webcamlist;
cam = string(wl(1));
video = webcam(cam);
preview(video)

centro = 0;

% Condizioni iniziali e variabili stimate angoli per rappresentazione
% orientamento smooth
angle01_est = 0;
angle02_est = 90;
k = 0.2;

poligonovoluto = 0;
costantidarea = [0.43301 1 1.72047 2.59807 3.363391 4.82842];

% Apotema
f = [0.289 0.5 0.688 0.866 1.038 1.207];

% Catturo immagini dal mio video
while(1)
    tic;
    img = snapshot(video);

    grayImage = rgb2gray(img);

    inverseGrayImage = uint8(255) - grayImage;

    % Due metodi di individuazione dell'imagine
    binary_image = imbinarize(inverseGrayImage,"adaptive","ForegroundPolarity","bright","Sensitivity",0.5);
    %     binary_image = imbinarize(inverseGrayImage,"global");

    % Connette spazi molto vicini
    binary_image = bwareaopen(binary_image,200);

    binary_image = imfill(binary_image,'holes');

    props1 = regionprops(binary_image, 'Area');
    %% Identifico i poligoni regolari e vedo quale poligono voglio inseguire
    aree = [props1.Area];

    % La struttura poligono serve per andare a confrontare ogni forma a
    % quale poligono potrebbe essere associato:
    % poligono(1) = è il poligono preso in esame nel momento stesso
    % poligono(2) = è l'associazione della forma migliore per un poligono che ho trovato, quindi conterrà il valore minimo prossimo allo 0
    poligono = [1000,1000];

    % numeroe è una riga (con numero di colonne quante sono le mie 'forme' trovate)
    % che una volta riempito ci dice ogni forma a che
    % poligono viene matchato, andando a mettere l'indice del vettore di costantidarea
    numeroe = zeros(1,length(aree));
    area = zeros(1,length(aree));

    % Manipolo le misure dei miei poligoni per trovare le costanti d'area e controllare se essi ci sono
    for i=1:1:length(aree)
        if(aree(i)>10000)      % Modificabile durante i test
            area(i) = i;
        end
    end
    
    % Trova le componenti connesse
    cc = bwconncomp(binary_image,8);
    grain = false(size(binary_image));
    for i=1:1:length(aree)
        if(area(i) ~=  0)
            grain(cc.PixelIdxList{i}) = true;
        end
    end
    
    % Da qui vado a riconoscere il poligono in base alle aree isolate
    props = regionprops(grain, 'Area', 'Perimeter','Centroid','Circularity');
    aree = [props.Area];
    perimetri = [props.Perimeter];
    circularity = [props.Circularity];

    for i=1:1:length(aree)

        % Controllo subito se è un cerchio, perché in caso non mi serve
        % riempire il numeroe(vettore nuemro lati di ogni poligono).
        if(abs(circularity(i) - 1) <= 0.1 && poligonovoluto == 0)
            centro = i;
            break;
        end

        for j=3:1:8
            lato = perimetri(i)/j;
            phi = aree(i)/lato^2;

            [poligono(1),numero] = min(abs(costantidarea - phi));

            if(poligono(1)<poligono(2) && poligono(1)<0.1)

                poligono(2) = poligono(1);
                numeroe(i) = numero;
            end
        end
        poligono = [1000,1000];
    end
    
    % Per come abbiamo numerato le costanti
    numeroe = numeroe+2;

    % Controllo se ho trovato qualcosa
    for i = 1:1:length(aree)
        if(numeroe(i) == poligonovoluto  && circularity(i)<=0.9 && poligonovoluto ~= 0)
            centro = i;
        end
    end
    
    % Usato per scorrere su radon
    theta = 1:180;

    if(centro ~= 0 && centro <= length([props.Area]))
        
        % Isolo il mio poligono
        cc = bwconncomp(grain,8);
        graina = false(size(grain));
        graina(cc.PixelIdxList{centro}) = true;

        % Uso radon per calcolo dell'orientamento
        [R, xp] = radon(graina, theta);
        
        % Vettore con i massimi di ogni colonna (quindi i picchi per ogni theta)
        [maxRadon,row_R_max] = max(R); 

        % Filtro per evitare picchi multipli
        windowSize = 10;
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        y = filter(b,a,maxRadon);

        %         hold on;
        %         figure(4);
        %         plot(maxRadon);
        %         hold on;
        %         plot(y);
        %         hold off;

        figure(3);
        imshow(grain);
        
        % Trovo i due picchi in ordine discendente
        [pks, locs] = findpeaks(y, 'SortStr', 'descend', 'NPeaks', 2); % Trovo i due picchi in ordine discendente
        
        % Stampo il baricentro dell'oggetto
        hold on;
        centroids = cat(1,props.Centroid);
        plot(centroids(centro,1), centroids(centro,2), 'b*');

        if(length(locs) == 2)

            angle1 = locs(1);

            angle2 = locs(2);

            % Legge di controllo sugli angoli
            angle1_est = angle01_est - k * (angle01_est - tand(angle1+90));
            angle2_est = angle02_est - k * (angle02_est - tand(angle2+90));

            angleOrient = (angle1 + angle2)/2;
            if ( sign(sind(angle1)) ~= sign(sind(angle2)) || sign(cosd(angle1)) ~= sign(cosd(angle2)) )
                angleOrient = angleOrient - 90;
            end

            angleOrient = atand(sind(angleOrient)/cosd(angleOrient));
            
            % Trovo le diagonali del mio poligono
            syms x diag1 diag2

            diag1 = centroids(centro,2) - angle1_est * ( x - centroids(centro,1));
            diag2 = centroids(centro,2) - angle2_est * ( x - centroids(centro,1));

            angle01_est = angle1_est;
            angle02_est = angle2_est;
            
            % Disegno le diagonali sul poligono
            fplot(diag1, 'g', 'LineWidth', 1.5)
            fplot(diag2, 'r', 'LineWidth', 1.5)
            hold off;

        end
        hold off;
    end
end
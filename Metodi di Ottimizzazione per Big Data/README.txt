Per lanciare il programma, innanziutto importare il file .csv su matlab come matrice numerica, dopodichè mettere il nome del file importato alla variabile train.
Si possono modificare le varie impostazioni della rete neurale, andando a modificare i parametri:
1. hiddenLayers per specificare quanti strati nascosti;
2. layersSz modificare dal secondo al penultimo valore del vettore per inserire i neuroni dei vari strati nascosti;
3. lambda per inserire i vari lambda con cui provare la rete;
4. step per modificare il learning rate;
5. l per scegliere la regolarizzazione se l1 o l2;
6. numEras per scegliere il numero di epoche desiderate.
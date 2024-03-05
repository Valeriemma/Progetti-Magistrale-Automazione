float angoloX = 0;
float angoloY = 0;
float angoloXp = 0;
float angoloYp = 0;

//Variabili di giunto
float q1 = 0;
float q2 = 0;
float q3 = 0;
float q4 = 0;
float q5 = 0;
float q6 = 0;

//Variabili di giunto del robot fantasma
float q1r = 0;
float q2r = 0;
float q3r = 0;
float q4r = 0;
float q5r = 0;
float q6r = 0;

float c = 0; //Cilindrico
float s = 0; //SCARA
float s1 = 0; //Sferico di 1°tipo
float s2 = 0; //Sferico di 2° tipo;
float a = 1; //Antropomorfo

float TT = -0.02; // Per rendere l'autovalore di q1 pari a 0.98 (lentino)

float tasto = 1;
float incremento = 1;
float rotas = 1;
float sdr = 1;

int i;

void setup()
{
  size(1600,800,P3D);
  background(255);
  directionalLight(126,126,126,0,0,0.7);
  fill(#AA983A);
  
}




void draw()
{
  background(255);
  fill(255);
  
  oscilloscopio();
  
  textSize(15);
  fill(0);
  
  text(" ROBOT --> 'TASTO' :", 640, 20);
  text(" Cilindrico --> 'C'", 660, 45);
  text(" SCARA --> 'R'" , 660,70); 
  text(" Sferico 1°tipo --> 'P'", 660, 95);
  text(" Sferico 2°tipo --> 'S'", 660, 120);
  text(" Antropomofo --> 'A'", 660, 145);
  
  if(c == 1) InfoC();
  if(s == 1) InfoR();
  if(s1 == 1) InfoP();
  if(s2 == 1) InfoS();
  if(a == 1) InfoA();
  
  text("VARIABILI DI GIUNTO:", 10, 20);
  text("q1:", 20, 45);
  text("q2:", 20, 70);
  text("q3:", 20, 95);
  text("q4:", 20, 120);
  text("q5:", 20, 145);
  text("q6:", 20, 170);
  
  if(c == 1) InfoC();
  if(s == 1) InfoR();
  if(s1 == 1) InfoP();
  if(s2 == 1) InfoS();
  if(a == 1) InfoA();
     
  translate(400,400,0);
  rotateY(-angoloY);
  rotateX(angoloX);
  
 
  fill(#AA983A);
  q1 = q1 + TT * (q1 - q1r);
  q2 = q2 + TT * (q2 - q2r);
  q3 = q3 + TT * (q3 - q3r);
  q4 = q4 + TT * (q4 - q4r);
  q5 = q5 + TT * (q5 - q5r);
  q6 = q6 + TT * (q6 - q6r);
  
  if(c == 1) Cilindrico();
  if(s == 1) SCARA();
  if(s1 == 1) Sferico1();
  if(s2 == 1) Sferico2();
  if(a == 1) Antropomorfo();
  
 
}


void Cilindrico()
{
  
  link(q1, 100, 0, 0, 1);     // Prima riga della tabella di DH
  link(0, q2, -PI/2, 0, 2);
  link(0, q3, 0, 0, 3);
  link(q4, 0, -PI/2, 0, 4);
  link(q5, 0, PI/2, 0, 5);
  link(q6, 100, 0, 0, 6);
  
}

void SCARA()
{
  link(q1, 100, 0, 100, 1);  //tabella di DH
  link(q2, 100, PI, 100, 2); //
  link(0, q3, 0, 0, 3);      //
  link(q4, 0, -PI/2, 0, 4);  //
  link(q5, 0, PI/2, 0, 5);   //
  link(q6, 100, 0, 0, 6);    //
}

void Sferico1()
{
  link(q1, 100, PI/2, 0, 1);  //tabella di DH
  link(q2, 0, PI/2, 100, 2);  //
  link(PI/2, q3, 0, 0, 3);    //
  link(q4, 0, -PI/2, 0, 4);   //
  link(q5, 0, PI/2, 0, 5);    //
  link(q6, 100, 0, 0, 6);     //
  
}


void Sferico2()
{
  link(q1, 100, -PI/2, 0, 1);  //tabella di DH
  link(q2, 100, PI/2, 0, 2);   //
  link(0, q3, 0, 0, 3);        //
  link(q4, 0, -PI/2, 0, 4);    //
  link(q5, 0, PI/2, 0, 5);     //
  link(q6, 100, 0, 0, 6);      //
  
}


void Antropomorfo()
{
  link(q1, 100, PI/2, 0, 1);     // Prima riga della tabella di DH
  link(q2, 0, 0, 100, 2);
  link(q3, 0, PI/2, 0, 3);
  link(q4, 100, -PI/2, 0, 4);
  link(q5, 0, PI/2, 0, 5);
  link(q6, 100, 0, 0, 6);
}

void link(float theta, float d, float alpha, float a, int id)
{
  if(rotas == 1) rotationAxesZ();
  if(sdr == 1 ) ViewSystems(id);    
  rotateZ(theta);
  sphere(25);
  translate(0, 0 ,-d/2);
  box(25, 25, d); 
  translate(0, 0 ,-d/2);
  rotateX(alpha);
  sphere(25);
  translate(-a/2, 0 ,0);
  box(a, 25, 25); 
  translate(-a/2, 0 , 0);
}


void reset()
{
  q1 = 0;
  q2 = 0;
  q3 = 0;
  q4 = 0;
  q5 = 0;
  q6 = 0;
}

void InfoC()
{
  textSize(25);
  text("Cilindrico",330,700);
  textSize(15);
  text(degrees(q1) % 360, 40, 45);
  text(q2, 40, 70);
  text(q3, 40, 95);
  text(degrees(q4) % 360, 40, 120);
  text(degrees(q5) % 360, 40, 145);
  text(degrees(q6) % 360, 40, 170); 
  
}

void InfoR()
{
   textSize(25);
  text("SCARA",330,700);
  textSize(15);
  text(degrees(q1) % 360, 40, 45);
  text(degrees(q2) % 360, 40, 70);
  text(q3, 40, 95);
  text(degrees(q4) % 360, 40, 120);
  text(degrees(q5) % 360, 40, 145);
  text(degrees(q6) % 360, 40, 170); 
}

void InfoP()
{
   textSize(25);
  text("Sferico 1°tipo",330,700);
  textSize(15);
  text(degrees(q1) % 360, 40, 45);
  text(degrees(q2) % 360, 40, 70);
  text(q3, 40, 95);
  text(degrees(q4) % 360, 40, 120);
  text(degrees(q5) % 360, 40, 145);
  text(degrees(q6) % 360, 40, 170); 
}

void InfoS()
{
  textSize(25);
  text("Sferico 2°tipo",330,700);
  textSize(15);
  text(degrees(q1) % 360, 40, 45);
  text(degrees(q2) % 360, 40, 70);
  text(q3, 40, 95);
  text(degrees(q4) % 360, 40, 120);
  text(degrees(q5) % 360, 40, 145);
  text(degrees(q6) % 360, 40, 170);
}

void InfoA()
{
  textSize(25);
  text("Antropomorfo",330,700);
  textSize(15);
  text(degrees(q1) % 360, 40, 45);
  text(degrees(q2) % 360, 40, 70);
  text(degrees(q3) % 360, 40, 95);
  text(degrees(q4) % 360, 40, 120);
  text(degrees(q5) % 360, 40, 145);
  text(degrees(q6) % 360, 40, 170);
}



void ViewSystems(int id){
  
    rotateX(PI/2);
    
   //SR della base asse X0
   pushMatrix();
   fill(255,0,0);
   translate(0,0,50);
   box(3,3,100);
   popMatrix();
   text("x"+str(id),-20,3,110);
        
   //SR della base asse Y0
   pushMatrix();
   fill(0,255,0);
   translate(50,0,0);
   box(100,3,3);
   popMatrix(); 
   text("y"+str(id),120,3);
  
   //SR della base asse Z0
   pushMatrix();
   fill(0,0,255);
   translate(0,-50,0);
   box(3,100,3);
   popMatrix();
   text("z"+str(id),-5,-120); 
   
   rotateX(-PI/2);
   
}


int wtable = 800;
int htable = 400;
int density = 40;
float k = 1;

float[] array1 = new float[wtable];
float[] array2 = new float[wtable];
float[] array3 = new float[wtable];
float[] array4 = new float[wtable];
float[] array5 = new float[wtable];
float[] array6 = new float[wtable];

float widthLine = 1;

void oscilloscopio()
{
 
  array1[799] = -q1*10;
  array2[799] = -q2*10;
  array3[799] = -q3*10;
  array4[799] = -q4*10;
  array5[799] = -q5*10;
  array6[799] = -q6*10;
//  xdis = wtable-k*0.1;
  push();
    translate(-25, 300);
    rect(800,75, wtable, htable);
    push();
      translate(800,275);
      fill(0);
      strokeWeight(2);
      line(0, 0, wtable, 0);
      strokeWeight(1);
      text("0", -10,0);
      for (int i = 0; i< wtable; i+=wtable/density)
      {
        strokeWeight(0.5);
        line(i, -htable/2, i, htable/2);
      }
      for (int i = -htable/2; i< htable/2; i+=2*htable/density)
      {
        strokeWeight(0.5);
        line(0, i, wtable, i);
      }
      for(int i = 0; i < 799; i++)
      {
         array1[i] = array1[i+1];
         array2[i] = array2[i+1];
         array3[i] = array3[i+1];
         array4[i] = array4[i+1];
         array5[i] = array5[i+1];
         array6[i] = array6[i+1];
      }
      for(int i = 0; i <800; i++)
      {
        stroke(255, 0, 0); 
        circle((wtable-(800-i)),array1[i],widthLine);
        
        stroke(0, 255, 0);
        circle((wtable-(800-i)),array2[i],widthLine);
        
        stroke(0, 0, 255);
        circle((wtable-(800-i)),array3[i],widthLine);
        
        stroke(255, 255, 0);
        circle((wtable-(800-i)),array4[i],widthLine);
        
        stroke(0, 255, 255);
        circle((wtable-(800-i)),array5[i],widthLine);
        
        stroke(255, 0, 255);
        circle((wtable-(800-i)),array6[i],widthLine);
        
      }
     
      k++;
      
      
    pop();
    
  
  pop();
}




void mousePressed()       //Metodo di traduzione da segemento ad angolo.
{
  angoloYp = angoloY + 3.14 * mouseX/float(500);
  angoloXp = angoloX + 3.14 * mouseY/float(500);
}

void mouseDragged()      //Metodo di traduzione da segemento ad angolo (trascinamento).
{
  angoloY = angoloYp - 3.14 * mouseX/float(500);
  angoloX = angoloXp - 3.14 * mouseY/float(500);
}

void keyPressed()
{
  if (keyCode == '1') tasto = 1;
  if (keyCode == '2') tasto = 2;
  if (keyCode == '3') tasto = 3;
  if (keyCode == '4') tasto = 4;
  if (keyCode == '5') tasto = 5;
  if (keyCode == '6') tasto = 6;
  
  if(keyCode == LEFT)
   {
    if(tasto == 1) q1r = q1r - incremento;
    if(tasto == 2) q2r = q2r - incremento;
    if(tasto == 3) q3r = q3r - incremento;
    if(tasto == 4) q4r = q4r - incremento;
    if(tasto == 5) q5r = q5r - incremento;
    if(tasto == 6) q6r = q6r - incremento;
   }

  if(keyCode == RIGHT)
   {
    if(tasto == 1) q1r = q1r + incremento;
    if(tasto == 2) q2r = q2r + incremento;
    if(tasto == 3) q3r = q3r + incremento;
    if(tasto == 4) q4r = q4r + incremento;
    if(tasto == 5) q5r = q5r + incremento;
    if(tasto == 6) q6r = q6r + incremento;
   }
   
   if(keyCode == 'C')
   {
     c = 1;
     s = 0; 
     s1 = 0; 
     s2 = 0; 
     a = 0; 
     reset();
   }

   if(keyCode == 'R')
   {
     s = 1;
     c = 0; 
     s1 = 0; 
     s2 = 0; 
     a = 0;
     reset();
   }
 
    if(keyCode == 'P')
   {
     s1 = 1;
     c = 0;
     s = 0;  
     s2 = 0; 
     a = 0;
     reset();
   }
   
   if(keyCode == 'S')
   {
     s1 = 0; 
     s2 = 1;
     c = 0;
     s = 0;  
     a = 0;
     reset();
   }
   
   if(keyCode == 'A')
   {
     a = 1;
     c = 0;
     s = 0; 
     s1 = 0; 
     s2 = 0; 
     reset();
   }
   
   if(keyCode == 'Z') rotas = -rotas;
   if(keyCode == 'F') sdr = -sdr;
}

void rotationAxesY()
{
  line(0,-200, 0, 200 );
}

void rotationAxesX()
{
  line(-200,0, 200, 0 );
}

void rotationAxesZ()
{
  line(0, 0, -200, 0, 0, 200 );
}

  program RAZVOROT;
  {          modernezirovannaya zadacha poluanaliticheskiy metod
   programma tochnogo resheniya zadachi optimizacii energii
               s zakreplennym vremenem
     dlya sfericheski  simmetrichnogo tela
     s obobcheniem na sluchay proizvolnogo tela  }
   {$N+}
   label met1,met2,met3;
   type m03=array [0..3] of extended;
        m3=array [1..3] of extended;
        m2=array [1..2] of extended;
        m9=array [1..9] of extended;
        m99=array [1..9,1..9] of extended;
   var n,nk,ig,j,j1,nit,nitk:integer;
   uz,C1,C2,C3,C4,C5,C6,C7,C8,f0,g0,ft,gt,t,dt,mlam,modm,tt,
   tk,snev,eps,delta,alphag1,alphag2,funkc,
   AI,BI,CI,S,modmob,funkcob  :extended;
   ske20,ske30,ke2t,ke3t,lamda0,lamdat,l0e2e3,lamom,kvaom,lamtt,
   lamdak,slamda0,sl0lk,ke1,ske1,ke2,ske2,ke21,ske12,
   l0e123,komega,kmom:m03;
   omegat,momt,omega0,omegak,momobcht:m3;
   upravt:m2;
   C0,CV,nev0,nevv,gamma:m9;
   A:m99;
   am:array [1..4] of extended;
   qlam:array [0..3,1..5] of extended;
   zapdvij,zapom,zapmom,zapnev,zmomob:text;
   function FF1(tr,C1r,C3r,C5r:extended):extended;
    begin
     FF1:=-0.25*C1r*tr*tr+0.5*C3r*tr+C5r;
       end;   {funkcii FF1  }
   function FF(tr,C1r,C3r,C5r:extended):extended;
    begin
     FF:=-C1r*tr*tr*tr/12.0+0.25*C3r*tr*tr+C5r*tr;
       end;   {funkcii FF  }
   function FG1(tr,C2r,C4r,C7r:extended):extended;
    begin
     FG1:=-0.25*C2r*tr*tr+0.5*C4r*tr+C7r;
       end;   {funkcii FG1  }
   function FG(tr,C2r,C4r,C7r,C8r:extended):extended;
    begin
     FG:=-C2r*tr*tr*tr/12.0+0.25*C4r*tr*tr+C7r*tr+C8r;
       end;   {funkcii FG  }
  procedure POMEGA(tr,C1r,C2r,C3r,C4r,C5r,C7r,C8r:extended;
                    var omegar:m3);
    var f1r,g1r,gr:extended;
     begin
     f1r:=FF1(tr,C1r,C3r,C5r);
     g1r:=FG1(tr,C2r,C4r,C7r);
     gr:=FG(tr,C2r,C4r,C7r,C8r);
     omegar[1]:=f1r*sin(gr);
     omegar[2]:=f1r*cos(gr);
     omegar[3]:=g1r;
       end;  { procedury POMEGA  }
 procedure PUPRAV(tr,C1r,C2r,C3r,C4r:extended; var upravr:m2);
      begin
     upravr[1]:=0.5*(-C1r*tr+C3r);
     upravr[2]:=0.5*(-C2r*tr+C4r);
       end;  {  procedury PUPRAV  }
 procedure PMOM(tr,C1r,C2r,C3r,C4r,C5r,C7r,C8r:extended;var momr:m3);
     var upravr:m2;
         f1r,g1r,gr:extended;
       begin
   PUPRAV(tr,C1r,C2r,C3r,C4r,upravr);
   f1r:=FF1(tr,C1r,C3r,C5r);
   g1r:=FG1(tr,C2r,C4r,C7r);
   gr:=FG(tr,C2r,C4r,C7r,C8r);
   momr[1]:=upravr[1]*sin(gr)+f1r*g1r*cos(gr);
   momr[2]:=upravr[1]*cos(gr)-f1r*g1r*sin(gr);
   momr[3]:=upravr[2];
     end;  {   procedury PUPRAV  }
 procedure PE2(fr:extended;var kvae2:m03);
     begin
      kvae2[0]:=cos(0.5*fr);
      kvae2[1]:=0.0;
      kvae2[2]:=sin(0.5*fr);
      kvae2[3]:=0.0;
         end;  { procedury PE2  }
 procedure PE3(gr:extended;var kvae3:m03);
     begin
      kvae3[0]:=cos(0.5*gr);
      kvae3[1]:=0.0;
      kvae3[2]:=0.0;
      kvae3[3]:=sin(0.5*gr);
         end;  { procedury PE3  }
           { процедура умножения кватернионов }
  procedure PUMKVA(ar,br:m03;var cr:m03);
    begin
   cr[0]:=ar[0]*br[0]-ar[1]*br[1]-ar[2]*br[2]-ar[3]*br[3];
   cr[1]:=ar[0]*br[1]+ar[1]*br[0]+ar[2]*br[3]-ar[3]*br[2];
   cr[2]:=ar[0]*br[2]-ar[1]*br[3]+ar[2]*br[0]+ar[3]*br[1];
   cr[3]:=ar[0]*br[3]+ar[1]*br[2]-ar[2]*br[1]+ar[3]*br[0];
     end; { процедуры PUMKVA }
   { процедура составления сопряженного кватерниона }
  procedure PSKVA(ar:m03;var asr:m03);
    begin
   asr[0]:=ar[0];  asr[1]:=-ar[1];  asr[2]:=-ar[2];  asr[3]:=-ar[3];
     end; { процедуры PSKVA }
   procedure PMOMOB(komega,kmom:m03;var momobcht:m3);
     begin
       momobcht[1]:=AI*kmom[1]+(CI-BI)*komega[2]*komega[3];
       momobcht[2]:=BI*kmom[2]+(AI-CI)*komega[1]*komega[3];
       momobcht[3]:=CI*kmom[3]+(BI-AI)*komega[1]*komega[2];
          end;  {   процедуры PMOMOB  }
   procedure PNEVYAZ(Crr:m9;var nev:m9);
    var ir:integer;
        C1r,C2r,C3r,C4r,C5r,C7r,C8r,alphar1,alphar2,
        f0r,g0r,fkr,gkr:extended;
        omega0r,omegakr:m3;
        l0lkr,ske20r,ske30r,ke1ra,ske1ra,ke2r,ke3r,ke2ra,ske2ra,
        kom0,komk,kom0sk,komksk,ksllsk,proiz,ke21ra,ske12ra:m03;
    begin
    C1r:=Crr[1];  C2r:=Crr[2];   C3r:=Crr[3];  C4r:=Crr[4];
    C5r:=Crr[5];  C7r:=Crr[6];   C8r:=Crr[7];
    alphar1:=Crr[8];     alphar2:=Crr[9];
   POMEGA(0.0,C1r,C2r,C3r,C4r,C5r,C7r,C8r,omega0r);
   POMEGA(tk,C1r,C2r,C3r,C4r,C5r,C7r,C8r,omegakr);
   f0r:=FF(0.0,C1r,C3r,C5r);
   g0r:=FG(0.0,C2r,C4r,C7r,C8r);
   PE2(f0r,ske20r);              PE3(g0r,ske30r);
   PSKVA(ske20r,ske20r);    PSKVA(ske30r,ske30r);
   ke1ra[0]:=cos(0.5*alphar1);   ke1ra[1]:=sin(0.5*alphar1);
   ke1ra[2]:=0.0;               ke1ra[3]:=0.0;
   PSKVA(ke1ra,ske1ra);
   ke2ra[0]:=cos(0.5*alphar2);   ke2ra[2]:=sin(0.5*alphar2);
   ke2ra[1]:=0.0;               ke2ra[3]:=0.0;
   PSKVA(ke2ra,ske2ra);
   fkr:=FF(tk,C1r,C3r,C5r);
   gkr:=FG(tk,C2r,C4r,C7r,C8r);
   PE2(fkr,ke2r);                PE3(gkr,ke3r);
   kom0[0]:=0.0;
   for ir:=1 to 3 do kom0[ir]:=omega0[ir];
   komk[0]:=0.0;
   for ir:=1 to 3 do komk[ir]:=omegak[ir];
   PUMKVA(ke2ra,ke1ra,ke21ra);
   PUMKVA(ske1ra,ske2ra,ske12ra);
   PUMKVA(ke21ra,kom0,kom0sk);   PUMKVA(kom0sk,ske12ra,kom0sk);
   PUMKVA(ke21ra,komk,komksk);   PUMKVA(komksk,ske12ra,komksk);
   PUMKVA(ske30r,ske20r,proiz);  PUMKVA(proiz,ke2r,proiz);
   PUMKVA(proiz,ke3r,proiz);
   PUMKVA(ke21ra,sl0lk,ksllsk);    PUMKVA(ksllsk,ske12ra,ksllsk);
   {   vychislenue nevyazok  }
   for ir:=1 to 3 do nev[ir]:=omega0r[ir]-kom0sk[ir];
   for ir:=1 to 3 do nev[ir+3]:=omegakr[ir]-komksk[ir];
   for ir:=0 to 2 do nev[ir+7]:=proiz[ir]-ksllsk[ir];


     end;  {  procedury NEVYAZ  }
          { процедура решения СЛАУ }
      procedure GAUS(ny:integer;ma:m99;mb:m9;var ru:m9);
      var i,j,i2,nom,nt1:integer;
      mag:m9;   max,mbg:extended{real};
      begin    {  начало процедуры }
      for i:=1 to ny do
       begin  { начало цикла по i }
       { выбор максимального элемента в i  столбце  }
       max:=ma[i,i];  nom:=i;
       for  j:=i+1 to ny do
        begin { начало цикла по j }
        if abs(max)<abs(ma[j,i]) then
         begin { начало оператора if }
      max:=ma[j,i];  nom:=j;
          end;  { конец оператора if }
          end;  { конец цикла по j }
       if nom<>i then
        begin { начало оператора if  по перестановке  строк  }
         for j:=i to ny do
           begin  { начало цикла по j }
       mag[j]:=ma[i,j];   ma[i,j]:=ma[nom,j];  ma[nom,j]:=mag[j];
          end;  { конец цикла пр  j }
       mbg:=mb[i]; mb[i]:=mb[nom];  mb[nom]:=mbg;
           end; { конец оператора  if }
    { нормализация и приведение к треугольному виду   }
     for j:=i to  ny do  ma[i,j]:=ma[i,j]/max;
     mb[i]:=mb[i]/max;
     for i2:=i+1 to ny do
      begin { начало цикла по  i2 }
      max:=ma[i2,i];
      for j:=i+1 to ny do ma[i2,j]:=ma[i2,j]-max*ma[i,j];
        mb[i2]:=mb[i2]-max*mb[i];
          end; { конец цикла  по   i2  }
           end;  { конец цикла по  i  }
      { определение решения СЛАУ      }
      for i:=ny downto 1 do
       begin { начало цикла по  i  }
       nt1:=i+1;  ru[i]:=mb[i];
       for j:=nt1 to ny do ru[i]:=ru[i]-ma[i,j]*ru[j];
        end ;  {  конец цикла по  i }
          end;{ процедуры GAUS }


   begin  {  GOLOVNAYA PROGRAMMA  }
   assign(zapdvij,'zdvij.st');   rewrite(zapdvij);
   assign(zapom,'zom.st');       rewrite(zapom);
   assign(zapmom,'zmom.st');     rewrite(zapmom);
   assign(zapnev,'znev.st');     rewrite(zapnev);
   assign(zmomob,'zmomob.st');   rewrite(zmomob);
   AI:=4853000.0;    BI:=23601000.0;   CI:=26278000.0;    {  MKC  }
 {  AI:=3400648.0;    BI:=21041672.0;   CI:=BI; }   {  Shatl  }
 {  AI:=1.0;           BI:=1.5;          CI:=0.6;  }
   writeln(zapdvij,'  razmernye momenty inercii');
   writeln(zapdvij,'  AI=',AI:10:2,'  BI=',BI:10:2,'  CI=',CI:10:2);
   S:=sqrt((AI*AI+BI*BI+CI*CI)/3.0);
   AI:=AI/S;      BI:=BI/S;      CI:=CI/S;
   writeln(zapdvij,'  bezrazmernye momenty inercii');
   writeln(zapdvij,'  AI=',AI:10:6,'  BI=',BI:10:6,'  CI=',CI:10:6);
   t:=0.0;   tk:=1.0;
   lamda0[0]:=0.79505;       lamda0[1]:=0.29814;
   lamda0[2]:=-0.39752;      lamda0[3]:=0.34783;
   mlam:=0.0;
   for ig:=0 to 3 do mlam:=mlam+sqr(lamda0[ig]);
   mlam:=sqrt(mlam);
   for ig:=0 to 3 do lamda0[ig]:=lamda0[ig]/mlam;
   omega0[1]:=0.27388;     omega0[2]:=-0.23883;    omega0[3]:=-0.3;
 {  omega0[1]:=0.0;     omega0[2]:=0.0;    omega0[3]:=0.000000125;  }
 {  lamdak[0]:=0.74807;       lamdak[1]:=0.5688;
   lamdak[2]:=-0.34181;      lamdak[3]:=0.00433;   }
   lamdak[0]:=0.84433;       lamdak[1]:=0.39846;
   lamdak[2]:=-0.326;      lamdak[3]:=0.14848;
   mlam:=0.0;
   for ig:=0 to 3 do mlam:=mlam+sqr(lamdak[ig]);
   mlam:=sqrt(mlam);
   for ig:=0 to 3 do lamdak[ig]:=lamdak[ig]/mlam;
   omegak[1]:=0.0;     omegak[2]:=0.0;    omegak[3]:=-0.59;
 {  omegak[1]:=0.0;     omegak[2]:=0.0;    omegak[3]:=-0.000000125;}
   PSKVA(lamda0,slamda0);  PUMKVA(slamda0,lamdak,sl0lk);
 {  Dlya nenulevyx uglovyx skorostey  }
   C0[1]:=2.0;       C0[2]:=2.8;        C0[3]:=1.5;
   C0[4]:=1.42;   C0[5]:=-0.25;       C0[6]:=-0.6;        C0[7]:=-0.3;
   C0[8]:=0.0;     C0[9]:=0.0;
  {  Dlya nulevyx uglovyx skorosteyi v nach i konech momenty vremeni  }
 {  C0[1]:=-1.0;       C0[2]:=-8.01;        C0[3]:=-0.5;
   C0[4]:=-4.06;   C0[5]:=0.0;       C0[6]:=-0.130;        C0[7]:=-0.3;
   C0[8]:=0.0;     C0[9]:=0.0;                                        }
   nit:=1;        nitk:=10;      eps:=0.0000005;   delta:=0.000001;
 met1:  PNEVYAZ(C0,nev0);
 writeln('   nomer iteracii =',nit:3);
 writeln('  C01=',C0[1]:8:5,'  C02=',C0[2]:8:5,'  C03=',C0[3]:8:5);
 writeln('  C04=',C0[4]:8:5,'  C05=',C0[5]:8:5,'  C06=',C0[6]:8:5);
 writeln('  C07=',C0[7]:8:5,'  C08=',C0[8]:8:5,'  C09=',C0[9]:8:5);
 writeln('  nev1=',nev0[1]:8:5,'  nev2=',nev0[2]:8:5,'  nev3=',nev0[3]:8:5);
 writeln('  nev4=',nev0[4]:8:5,'  nev5=',nev0[5]:8:5,'  nev6=',nev0[6]:8:5);
 writeln('  nev7=',nev0[7]:8:5,'  nev8=',nev0[8]:8:5,'  nev9=',nev0[9]:8:5);
 writeln(zapnev,'   nomer iteracii =',nit:3);
 writeln(zapnev,'  C01=',C0[1]:8:5,'  C02=',C0[2]:8:5,'  C03=',C0[3]:8:5);
 writeln(zapnev,'  C04=',C0[4]:8:5,'  C05=',C0[5]:8:5,'  C06=',C0[6]:8:5);
 writeln(zapnev,'  C07=',C0[7]:8:5,'  C08=',C0[8]:8:5,'  C09=',C0[9]:8:5);
 writeln(zapnev,'  nev1=',nev0[1]:8:5,'  nev2=',nev0[2]:8:5,
                '  nev3=',nev0[3]:8:5);
 writeln(zapnev,'  nev4=',nev0[4]:8:5,'  nev5=',nev0[5]:8:5,
                '  nev6=',nev0[6]:8:5);
 writeln(zapnev,'  nev7=',nev0[7]:8:5,'  nev8=',nev0[8]:8:5,
                '  nev9=',nev0[9]:8:5);
 snev:=0.0;
 for ig:=1 to 9 do snev:=snev+sqr(nev0[ig]);
 snev:=sqrt(snev);
 writeln('   snev=',snev:8:5);
 writeln(zapnev,'   snev=',snev:8:5);
 writeln('  PRESS Enter ');
 readln;
 if snev<eps then goto met2;
 if nit>nitk then
     begin
   writeln('   prevysheno chislo iteraciy');
   writeln('   PRESS Enter');   readln;
   goto  met3;
     end;
 for ig:=1 to 9 do
   begin
 CV:=C0;   CV[ig]:=C0[ig]+delta;
 PNEVYAZ(CV,nevv);
 for j:=1 to 9 do  A[j,ig]:=(nevv[j]-nev0[j])/delta;
     end; { cikla po ig }
 for j:=1 to 9 do nev0[j]:=-nev0[j];
 GAUS(9,A,nev0,gamma);
 for j:=1 to 9 do C0[j]:=C0[j]+gamma[j];
 nit:=nit+1; goto met1;
 met2:
    C1:=C0[1];       C2:=C0[2];     C3:=C0[3];     C4:=C0[4];
    C5:=C0[5];       C7:=C0[6];     C8:=C0[7];     alphag1:=C0[8];
    alphag2:=C0[9];
  writeln(zapdvij,'  RESHENIE ZADACHI S ENERGETICHESKIM FUNKCIONALOM');
  writeln(zapdvij,'  POLUANALITICHESKOE RESHENIE');
  writeln(zapdvij,'  NACHALNOE SOSTOYANIE');
  writeln(zapdvij,'  lam0=',lamda0[0]:8:5,'  lam1=',lamda0[1]:8:5);
  writeln(zapdvij,'  lam2=',lamda0[2]:8:5,'  lam3=',lamda0[3]:8:5);
  writeln(zapdvij,'  om1=',omega0[1]:8:5,'  om2=',omega0[2]:8:5);
  writeln(zapdvij,'  om3=',omega0[3]:8:5);
  writeln(zapdvij,'  KONECNOE SOSTOYANIE');
  writeln(zapdvij,'  lam0=',lamdak[0]:8:5,'  lam1=',lamdak[1]:8:5);
  writeln(zapdvij,'  lam2=',lamdak[2]:8:5,'  lam3=',lamdak[3]:8:5);
  writeln(zapdvij,'  om1=',omegak[1]:8:5,'  om2=',omegak[2]:8:5);
  writeln(zapdvij,'  om3=',omegak[3]:8:5);
  writeln(zapdvij,'   CONSTANTY');
  writeln(zapdvij,'  C1=',C1:8:5,'  C2=',C2:8:5,'  C3=',C3:8:5);
  writeln(zapdvij,'  C4=',C4:8:5,'  C5=',C5:8:5,'  C6=0.0');
  writeln(zapdvij,'  C7=',C7:8:5,'  C8=',C8:8:5);
  writeln(zapdvij,'  tk=',tk:8:5,'  alpha1=',alphag1:8:5,
                  '  alpha2=',alphag2:8:5);
  nk:=100;
  dt:=tk/nk;
    writeln(zapdvij,'t':5,'lam0':10,'lam1':10,'lam2':10,'lam3':10);
  writeln(zapom,'  RESHENIE ZADACHI S ENERGETICHESKIM FUNKCIONALOM');
  writeln(zapom,'  POLUANALITICHESKOE RESHENIE');
   writeln(zapom,'t':5,'om1':10,'om2':10,'om3':10);
  writeln(zapmom,'  RESHENIE ZADACHI S ENERGETICHESKIM FUNKCIONALOM');
  writeln(zapmom,'  POLUANALITICHESKOE RESHENIE');
   writeln(zapmom,'t':5,'m0m1':10,'mom2':10,'mom3':10,'modm':10,
                  'uprav1':10,'uprav2':10);
  writeln(zmomob,'  RESHENIE ZADACHI S ENERGETICHESKIM FUNKCIONALOM');
  writeln(zmomob,'  POLUANALITICHESKOE RESHENIE DLYA PROIZVOLNOGO TELA');
  writeln(zmomob,'t':5,'momob1':10,'momob2':10,'momob3':10,'modmob':10);
   POMEGA(t,C1,C2,C3,C4,C5,C7,C8,omegat);
   PMOM(t,C1,C2,C3,C4,C5,C7,C8,momt);
 {  modm:=0.0;
   for ig:=1 to 3 do modm:=modm+sqr(momt[ig]);
   modm:=sqrt(modm); }
   PUPRAV(t,C1,C2,C3,C4,upravt);
   f0:=FF(t,C1,C3,C5);
   g0:=FG(t,C2,C4,C7,C8);
 {  writeln('  f0=',f0:10:5,'  g0=',g0:10:5);  }
   PE2(f0,ske20);              PE3(g0,ske30);
   PSKVA(ske20,ske20);    PSKVA(ske30,ske30);
   ke1[0]:=cos(0.5*alphag1);     ke1[1]:=sin(0.5*alphag1);
   ke1[2]:=0.0;                ke1[3]:=0.0;
   PSKVA(ke1,ske1);
   ke2[0]:=cos(0.5*alphag2);     ke2[2]:=sin(0.5*alphag2);
   ke2[1]:=0.0;                ke2[3]:=0.0;
   PSKVA(ke2,ske2);
   PUMKVA(ke2,ke1,ke21);       PUMKVA(ske1,ske2,ske12);
   komega[0]:=0.0;              komega[1]:=omegat[1];
   komega[2]:=omegat[2];        komega[3]:=omegat[3];
   PUMKVA(ske12,komega,komega);       PUMKVA(komega,ke21,komega);
   kmom[0]:=0.0;                kmom[1]:=momt[1];
   kmom[2]:=momt[2];            kmom[3]:=momt[3];
   PUMKVA(ske12,kmom,kmom);       PUMKVA(kmom,ke21,kmom);
   modm:=0.0;
   for ig:=1 to 3 do modm:=modm+sqr(kmom[ig]);
   modm:=sqrt(modm);
 {  writeln('   PRESS Enter');
   readln;}
   PUMKVA(lamda0,ske12,l0e123);
   PUMKVA(l0e123,ske30,l0e123);
   PUMKVA(l0e123,ske20,l0e123);
 {  writeln(zapdvij,l0e2e3[0]:10:5,l0e2e3[1]:10:5,
                   l0e2e3[2]:10:5,l0e2e3[3]:10:5);}
   writeln(zapdvij,t:8:5,lamda0[0]:10:5,lamda0[1]:10:5,
                   lamda0[2]:10:5,lamda0[3]:10:5);
   writeln(zapom,t:8:5,komega[1]:10:5,komega[2]:10:5,komega[3]:10:5);
   writeln(zapmom,t:8:5,kmom[1]:10:5,kmom[2]:10:5,kmom[3]:10:5,modm:10:5,
                  upravt[1]:10:5,upravt[2]:10:5);
   PMOMOB(komega,kmom,momobcht);
   modmob:=0.0;
   for ig:=1 to 3 do modmob:=modmob+sqr(momobcht[ig]);
   modmob:=sqrt(modmob);
   writeln(zmomob,t:8:5,momobcht[1]:10:5,momobcht[2]:10:5,momobcht[3]:10:5,
                  modmob:10:5);
   funkc:=modm*modm;
   funkcob:=modmob*modmob;
   for n:=1 to nk do
     begin
      t:=n*dt;
   POMEGA(t,C1,C2,C3,C4,C5,C7,C8,omegat);
   PMOM(t,C1,C2,C3,C4,C5,C7,C8,momt);
   komega[0]:=0.0;              komega[1]:=omegat[1];
   komega[2]:=omegat[2];        komega[3]:=omegat[3];
   PUMKVA(ske12,komega,komega);       PUMKVA(komega,ke21,komega);
   kmom[0]:=0.0;                kmom[1]:=momt[1];
   kmom[2]:=momt[2];            kmom[3]:=momt[3];
   PUMKVA(ske12,kmom,kmom);       PUMKVA(kmom,ke21,kmom);
   PMOMOB(komega,kmom,momobcht);
   modmob:=0.0;
   for ig:=1 to 3 do modmob:=modmob+sqr(momobcht[ig]);
   modmob:=sqrt(modmob);
   modm:=0.0;
   for ig:=1 to 3 do modm:=modm+sqr(kmom[ig]);

   modm:=sqrt(modm);
   PUPRAV(t,C1,C2,C3,C4,upravt);
   ft:=FF(t,C1,C3,C5);
   gt:=FG(t,C2,C4,C7,C8);
   PE2(ft,ke2t);                PE3(gt,ke3t);
   PUMKVA(l0e123,ke2t,lamdat);
   PUMKVA(lamdat,ke3t,lamdat);
   PUMKVA(lamdat,ke21,lamdat);
   writeln(zapdvij,t:8:5,lamdat[0]:10:5,lamdat[1]:10:5,
                   lamdat[2]:10:5,lamdat[3]:10:5);
   writeln(zapom,t:8:5,komega[1]:10:5,komega[2]:10:5,komega[3]:10:5);
   writeln(zapmom,t:8:5,kmom[1]:10:5,kmom[2]:10:5,kmom[3]:10:5,modm:10:5,
                  upravt[1]:10:5,upravt[2]:10:5);
   writeln(zmomob,t:8:5,momobcht[1]:10:5,momobcht[2]:10:5,momobcht[3]:10:5,
                  modmob:10:5);
   if n mod 2=1 then
    funkc:=funkc+4.0*modm*modm
     else
    funkc:=funkc+2.0*modm*modm;
   if n mod 2=1 then
    funkcob:=funkcob+4.0*modmob*modmob
     else
    funkcob:=funkcob+2.0*modmob*modmob;
       end; {  cikla po n }
    funkc:=funkc-modm*modm;
    funkc:=funkc*dt/3.0;
    writeln(zapmom,'   znachenie funkcionala =',funkc:10:5);
    funkcob:=funkcob-modmob*modmob;
    funkcob:=funkcob*dt/3.0;
    writeln(zmomob,'   znachenie funkcionala =',funkcob:10:5);
 met3:close(zapdvij);       close(zapom);    close(zapmom); close(zapnev);
    close(zmomob);
     end.
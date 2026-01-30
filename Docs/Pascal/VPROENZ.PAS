
  program RAZVOROT;
  {$N+}
  { программа расчета оптимального разворота
       динамически произвольного тела za fiksirovannyy promejutok vremeni
       с функцианалом интеграл(mom*mom)dt  }
  label 1,2,3;
  type
  m3=array [1..3] of extended {real};
  m35=array [1..3,1..5] of extended  { real};
  m03=array [0..3] of extended { real};
  m035=array [0..3,1..5] of extended  { real};
  m5=array [1..5] of extended  { real};
  m6=array [1..6] of extended  { real};
  m66=array [1..6,1..6] of extended  {real};
  var
  nit,nitk,ig,jg,ndel,pvst,upd,mnojt,mnojl,mnojom,mnojm,nk:integer;
  alfa1,alfa2b,ht,eps,eps1,delta,
  tk,snev0,snevv,snevz,sgamma,kappa,kappaz,
  mlam,A,B,C,SABC,mfi0,teta,sinal,cv: extended  { real};
  lam0,lamk,slam0,kvape:m03;
  omega0,omegak,p00,p0v,nu00,nu0v:m3;
  nev0,nevv,gamma:m6;
  anev:m66;
  yg0,tgx,dtgx,tgl0,tgom0,tgm0:integer;
  zapdvij,zapup,zapnev,zapint,zapintv:text;
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
     {  процедура векторного произведения }
  procedure PUMVEK(ar,br:m3;var cr:m3);
     begin
     cr[1]:=ar[2]*br[3]-ar[3]*br[2];
     cr[2]:=ar[3]*br[1]-ar[1]*br[3];
     cr[3]:=ar[1]*br[2]-ar[2]*br[1];
      end; {  процедуры PUMVEK }
      {  функция скалярного произведения векторов }
  function SCAL3(ar,br:m3):extended;
    begin
    SCAL3:=ar[1]*br[1]+ar[2]*br[2]+ar[3]*br[3];
       end;  { функции SCAL3 }
      {  процедура умножения матрицы L на вектор }
  procedure PL(ar:m03;br:m3;var cr:m03);
    begin
    cr[0]:=-ar[1]*br[1]-ar[2]*br[2]-ar[3]*br[3];
    cr[1]:=ar[0]*br[1]-ar[3]*br[2]+ar[2]*br[3];
    cr[2]:=ar[3]*br[1]+ar[0]*br[2]-ar[1]*br[3];
    cr[3]:=-ar[2]*br[1]+ar[1]*br[2]+ar[0]*br[3];
      end; { процедуры PL }
      {  процедура умножения матрицы R0 на вектор }
  procedure PR0(ar:m3;var br:m3);
    begin
     br[1]:=ar[1]/A;    br[2]:=ar[2]/B;    br[3]:=ar[3]/C;
       end;   {  процедуры PR0 }
      {  процедура умножения матрицы R1 на вектор }
  procedure PR1(ar:m3;var br:m3);
    begin
     br[1]:=(C-B)*ar[2]*ar[3]/A;
     br[2]:=(A-C)*ar[3]*ar[1]/B;
     br[3]:=(B-A)*ar[1]*ar[2]/C;
       end;   {  процедуры PR1 }
      {  процедура умножения матрицы R на вектор }
  procedure PR(ar,br:m3;var cr:m3);
    begin
     cr[1]:=(A-C)*ar[3]*br[2]/B+(B-A)*ar[2]*br[3]/C;
     cr[2]:=(C-B)*ar[3]*br[1]/A+(B-A)*ar[1]*br[3]/C;
     cr[3]:=(C-B)*ar[2]*br[1]/A+(A-C)*ar[1]*br[2]/B;
       end;   {  процедуры PR1 }
       { процедура определения оптимального управления }
  procedure MOMOPT(nur:m3;var momopr:m3);
   var mnur:extended ;
   pr0nur:m3;
   ir:integer;
    begin
    PR0(nur,pr0nur);
     for ir:=1 to 3 do momopr[ir]:=0.5*pr0nur[ir];
      end; { процедуры POPTPE }

    { процедура построения кватерниона OMEGA }
  procedure POMEGA(omegar:m3; var kvaomr:m03);
  var ir:integer;
    begin
   kvaomr[0]:=0.0;
   for ir:=1 to 3 do kvaomr[ir]:=omegar[ir];
     end; { процедуры POMEGA }
     { процедура вычисления приращения кватернионной переменной }
  procedure PPKVA(f:m03;qf:m035;var fn:m03);
    var ir:integer;
     begin
      for ir:=0 to 3 do
    fn[ir]:=f[ir]+(qf[ir,2]+2.0*qf[ir,3]+2.0*qf[ir,4]+qf[ir,5])/6.0;
        end; { процедуры PPKVA }
     { процедура вычисления приращения векторной переменной }
  procedure PPVEK(f:m3;qf:m35;var fn:m3);
    var ir:integer;
     begin
      for ir:=1 to 3 do
    fn[ir]:=f[ir]+(qf[ir,2]+2.0*qf[ir,3]+2.0*qf[ir,4]+qf[ir,5])/6.0;
        end; { процедуры PPVEK }
      { процедура выполнения шага по методу Рунге-Кутта }
  procedure RK(omegap,pp,nup:m3;tp:extended {real};
  lamp:m03;
         var omeganp,pnp,nunp:m3;var tnp:extended {real};
         var lamnp:m03);
       var i,j,j1:integer;
       lamt,kvaom,qlom:m03;
       pt,omegat,nut,mom,qpom,r0mom,r1om,romnu:m3;
       am:m5;
       qp,qom,qnu:m35;
       qlam:m035;
         begin { начало процедуры RK }
    { заполнение вспомогательных массивов }
   am[1]:=0.0;  am[2]:=0.5;  am[3]:=0.5;  am[4]:=1.0;
    for i:=0 to 3 do   qlam[i,1]:=0.0;
    for i:=1 to 3 do
      begin
        qp[i,1]:=0.0; qom[i,1]:=0.0;  qnu[i,1]:=0.0;
        end;
     {  интегрирование системы дифференциальных уравнений }
     for j:=1 to 4 do
      begin { начало цикла по j }
     { вычисление переменных внутри шага Рунге-Кутта }
      for i:=0 to 3 do
      lamt[i]:=lamp[i]+am[j]*qlam[i,j];
      for i:=1 to 3 do
       begin
      pt[i]:=pp[i]+am[j]*qp[i,j];
      omegat[i]:=omegap[i]+am[j]*qom[i,j];
      nut[i]:=nup[i]+am[j]*qnu[i,j];
        end; { цикла по i }
     { вычисление вектора mom, кватерниона kvaom }
      MOMOPT(nut,mom);
      j1:=j+1; { определение составляющих приращений }
      PL(lamt,omegat,qlom);  PUMVEK(pt,omegat,qpom);
      PR0(mom,r0mom);        PR1(omegat,r1om);
      PR(omegat,nut,romnu);
      for i:=0 to 3 do   qlam[i,j1]:=0.5*qlom[i]*ht;
      for i:=1 to 3 do
       begin
        qom[i,j1]:=(r0mom[i]-r1om[i])*ht;
        qp[i,j1]:=qpom[i]*ht;
        qnu[i,j1]:=(-0.5*pt[i]+romnu[i])*ht;
          end;
             end; {цикла по j}
       { вычисление значений фазовых и сопряженных переменных
             в правой точке шага }
       PPKVA(lamp,qlam,lamnp);    tnp:=tp+ht;
       PPVEK(omegap,qom,omeganp);
       PPVEK(pp,qp,pnp);          PPVEK(nup,qnu,nunp);
        end;  {  процедуры  RK }
    { процедура решения задачи Коши и вычисления невязок }
    procedure RZCOSHI(up:integer;p0,nu0:m3;var nev:m6);
      var  n,nm,nmm,ns,i:integer;
      t,tn,htm,htmm,ht1,ht2,opl,opp,funk,funint,modmom  :extended {real};
      lam,lamn,slam,nev13,llamp,kvaint:m03;
      mom,momn,omega,omegan,p,pn,nu,nun,r0mom,r1om,r01,nuom,vekint:m3;
      { процедура пересчета координат положения и скоростей в подвижной
       и неподвижной системах отсчета }
      procedure PECHAT;
      var nr:integer;
      begin
      writeln(zapdvij,t:9:5,lam[0]:9:5,lam[1]:9:5,lam[2]:9:5,lam[3]:9:5,
      omega[1]:9:5,omega[2]:9:5,omega[3]:9:5);
      MOMOPT(nu,mom);
      modmom:=sqrt(SCAL3(mom,mom));
      writeln(zapup,t:9:5,mom[1]:9:5,mom[2]:9:5,mom[3]:9:5,modmom:9:5);
      PL(lam,p,llamp);   PSKVA(lam,slam);    PUMKVA(llamp,slam,kvaint);
      writeln(zapint,t:9:5,kvaint[0]:9:5,kvaint[1]:9:5,kvaint[2]:9:5,
      kvaint[3]:9:5);
      PUMVEK(nu,omega,nuom);
      for nr:=1 to 3 do vekint[nr]:=0.5*p[nr]+nuom[nr];
      writeln(zapintv,t:9:5,vekint[1]:9:5,vekint[2]:9:5,vekint[3]:9:5);
     end;    { процедуры PECHAT }
      begin { начало  процедуры  RZCOSHI }
      { присвоение начальных значений }
      t:=0.0;    lam:=lam0;  omega:=omega0;  nu:=nu0;  p:=p0;
      { определение числа шагов и величины шага }
    {  nk:=trunc(tk/(2.0*ht0));      ns:=nk;     nk:=2*nk;}
       {writeln(' nk=',nk:4);readln;}
    {  ht:=tk/nk;}
    {  вычисление управлений КА и печать в файлы }
       if up=1 then
      begin
    PECHAT;
      MOMOPT(nu,mom);
      funk:=SCAL3(mom,mom);
    end;
    { интегрирование системы методом Рунге-Кутта }
    for n:=1 to nk do
     begin { начало цикла по n }
      RK(omega,p,nu,t,lam,omegan,pn,nun,tn,lamn);
    { перенос результатов из правой точки шага в левую }
                t:=tn;
              lam:=lamn;   omega:=omegan;  p:=pn;  nu:=nun;
       if ( up=1 ) and ( n mod 5=0 ) then   PECHAT;
       if ( up=1 ) and ( n=ns ) then
         begin
        writeln(zapdvij,'  srednyaya tochka');
        writeln(zapup,'  srednyaya tochka');
          PECHAT;
            end;
       if up=1 then
        begin
        MOMOPT(nu,mom);
        funint:=SCAL3(mom,mom);
        if n mod 2=1 then
        funk:=funk+4.0*funint
          else
        funk:=funk+2.0*funint;
         end;
           end; { цикла по n }
     if ( up=1 ) and ( nk mod 5<>0 ) then   PECHAT;
     if up=1 then
       begin
        funk:=funk-funint;
        funk:=funk*ht/3.0;
        writeln(zapup,'   ZNACHENIE FUNKCIONALA= ',funk:8:6);
          end;
   {  if upt=1 then
     begin
      RK(omega,p,nu,t,delta*1.0,lam,omegan,pn,nun,tn,lamn);}
    { перенос результатов из правой точки шага в левую }
             {   t:=tn;
              lam:=lamn;   omega:=omegan;  p:=pn;  nu:=nun;
     end;  оператора if }

     { вычисление невязок }
     PSKVA(lam,slam);
     PUMKVA(slam,lamk,nev13);
      MOMOPT(nu,mom);   PR0(mom,r0mom);   PR1(omega,r1om);
     for i:=1 to 3 do
      begin
      r01[i]:=r0mom[i]-r1om[i];
      nev[i]:=nev13[i];  nev[3+i]:=omega[i]-omegak[i];
      end;
   {   nev[7]:=-1.0-SCAL3(mom,mom);
      nev[7]:=nev[7]+0.5*SCAL3(omega,p)+SCAL3(nu,r01); }
   {  for i:=1 to 7 do nev[i]:=1000.0*nev[i];  }
    end; { процедуры RZCOSHI }
      { процедура решения СЛАУ }
      procedure GAUS(ny:integer;ma:m66;mb:m6;var ru:m6);
      var i,j,i2,nom,nt1:integer;
      mag:m6;   max,mbg:extended{real};
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


       BEGIN { ГОЛОВНАЯ ПРОГРАММА   }
       assign(zapdvij,'zdvij1.st');   rewrite(zapdvij);
       { файл кватерниона положения и угловой скорости }
       assign(zapup,'uprav.st');   rewrite(zapup);
       {  файл управляющего момента }
       assign(zapnev,'nev.st');    rewrite(zapnev);
       { файл невязок  }
       assign(zapint,'zint.st');   rewrite(zapint);
       assign(zapintv,'zintv.st');   rewrite(zapintv);
       writeln(zapdvij,'    РЕШЕНИЕ ЗАДАЧИ ОБ ОПТИМАЛЬНОМ РАЗВОРОТЕ');
       writeln(zapdvij,'        ПРОИЗВОЛЬНОГО ТВЕРДОГО ТЕЛА');
       writeln(zapup,'    РЕШЕНИЕ ЗАДАЧИ ОБ ОПТИМАЛЬНОМ РАЗВОРОТЕ');
       writeln(zapup,'        ПРОИЗВОЛЬНОГО ТВЕРДОГО ТЕЛА');
       writeln(zapnev,'    РЕШЕНИЕ ЗАДАЧИ ОБ ОПТИМАЛЬНОМ РАЗВОРОТЕ');
       writeln(zapnev,'        ПРОИЗВОЛЬНОГО ТВЕРДОГО ТЕЛА');
       writeln(zapint,'    РЕШЕНИЕ ЗАДАЧИ ОБ ОПТИМАЛЬНОМ РАЗВОРОТЕ');
       writeln(zapint,'        ПРОИЗВОЛЬНОГО ТВЕРДОГО ТЕЛА');
       writeln(zapintv,'    РЕШЕНИЕ ЗАДАЧИ ОБ ОПТИМАЛЬНОМ РАЗВОРОТЕ');
       writeln(zapintv,'        ПРОИЗВОЛЬНОГО ТВЕРДОГО ТЕЛА');
       tk:=1.0;    ht:=0.002;          nk:=500;
       { ввод исходных параметров задачи }
  {     A:=1.0;     B:=1.0;    C:=1.0;  }    {  главные моменты инерции }
  {     A:=1.0;     B:=1.5;    C:=0.6;  }    {  главные моменты инерции }
  {     A:=1.0;     B:=1.2;    C:=0.8;   }   {  главные моменты инерции }
  {     A:=1.0;     B:=1.4;    C:=0.6;   }   {  главные моменты инерции }
{  A:=3400648.0;   B:=21041672.0;  C:=B;}  {  главные моменты инерции Shatl }
  A:=4853000.0;  B:=23601000.0;  C:=26278000.0; {mom inerc  MKS }
    SABC:=sqrt((A*A+B*B+C*C)/3.0);
       A:=A/SABC;      B:=B/SABC;      C:=C/SABC;
       writeln(zapdvij,'   главные моменты инерции тела');
       writeln(zapdvij,'   A=',A:8:5,'   B=',B:8:5,'   C=',C:8:5);
       writeln(zapup,'   главные моменты инерции тела');
       writeln(zapup,'   A=',A:8:5,'   B=',B:8:5,'   C=',C:8:5);
       writeln(zapnev,'   главные моменты инерции тела');
       writeln(zapnev,'   A=',A:8:5,'   B=',B:8:5,'   C=',C:8:5);
       writeln(zapint,'   главные моменты инерции тела');
       writeln(zapintv,'   A=',A:8:5,'   B=',B:8:5,'   C=',C:8:4);
       writeln(zapintv,'   главные моменты инерции тела');
       writeln(zapint,'   A=',A:8:5,'   B=',B:8:5,'   C=',C:8:5);
       {  начальное состояние твердого тела}
    (*   lam0[0]:=0.8;               lam0[1]:=0.25;
       lam0[2]:=-0.56;               lam0[3]:=0.1;
       { нормализация кватерниона }
       mlam:=0.0;
       for ig:=0 to 3 do mlam:=mlam+sqr(lam0[ig]);
       mlam:=sqrt(mlam);
       for ig:=0 to 3 do lam0[ig]:=lam0[ig]/mlam;
       omega0[1]:=0.5;   omega0[2]:=0.75;   omega0[3]:=-0.35;
       {  конечное состояние твердого тела}
       lamk[0]:=0.0;               lamk[1]:=0.45;
       lamk[2]:=0.9;               lamk[3]:=0.0;
       { нормализация кватерниона }
       mlam:=0.0;
       for ig:=0 to 3 do mlam:=mlam+sqr(lamk[ig]);
       mlam:=sqrt(mlam);
       for ig:=0 to 3 do lamk[ig]:=lamk[ig]/mlam;
       omegak[1]:=0.0;   omegak[2]:=0.0;   omegak[3]:=0.0;*)
       {  начальное состояние твердого тела}
    (*   lam0[0]:=1.0;               lam0[1]:=0.0;
       lam0[2]:=0.0;               lam0[3]:=0.0;
       { нормализация кватерниона }
       mlam:=0.0;
       for ig:=0 to 3 do mlam:=mlam+sqr(lam0[ig]);
       mlam:=sqrt(mlam);
       for ig:=0 to 3 do lam0[ig]:=lam0[ig]/mlam;
       omega0[1]:=0.58;   omega0[2]:=0.36;   omega0[3]:=-0.33;  *)
       {  начальное состояние твердого тела}
       lam0[0]:=0.79505;               lam0[1]:=0.29814;
       lam0[2]:=-0.39752;               lam0[3]:=0.34783;
       { нормализация кватерниона }
       mlam:=0.0;
       for ig:=0 to 3 do mlam:=mlam+sqr(lam0[ig]);
       mlam:=sqrt(mlam);
       for ig:=0 to 3 do lam0[ig]:=lam0[ig]/mlam;
  {     omega0[1]:=0.27388;   omega0[2]:=-0.23883;   omega0[3]:=-0.3; }
  {     omega0[1]:=0.0;   omega0[2]:=0.0;   omega0[3]:=0.0; }
 {   omega0[1]:=0.0326808;   omega0[2]:=0.1011911;   omega0[3]:=-0.4749187;}
    omega0[1]:=0.27388;   omega0[2]:=-0.23883;   omega0[3]:=-0.3;
       {  конечное состояние твердого тела}
  {     lamk[0]:=0.784734;               lamk[1]:=0.47384;
       lamk[2]:=0.312;               lamk[3]:=-0.193;      }
  {     lamk[0]:=0.67936;               lamk[1]:=0.4852;
       lamk[2]:=0.312;               lamk[3]:=-0.31933;   }
       {  конечное состояние твердого тела}
   (*    lamk[0]:=0.793618;               lamk[1]:=0.485231;
       lamk[2]:=0.312002;               lamk[3]:=-0.193328; *)
        {  конечное состояние твердого тела}
       lamk[0]:=0.84434;               lamk[1]:=0.39846;
       lamk[2]:=-0.326;               lamk[3]:=0.14848;
       { нормализация кватерниона }
       mlam:=0.0;
       for ig:=0 to 3 do mlam:=mlam+sqr(lamk[ig]);
       mlam:=sqrt(mlam);
       for ig:=0 to 3 do lamk[ig]:=lamk[ig]/mlam;
  {     omegak[1]:=0.669197;   omegak[2]:=0.452757;   omegak[3]:=-0.258444;}
  (*     omegak[1]:=0.6692;   omegak[2]:=0.4528;   omegak[3]:=-0.2584;  *)
       omegak[1]:=0.0;   omegak[2]:=0.0;   omegak[3]:=-0.59;
 {      omegak[1]:=0.0;   omegak[2]:=0.0;   omegak[3]:=0.0;  }
 {  omegak[1]:=0.0326808;   omegak[2]:=-0.1713174;   omegak[3]:=-0.4543543; }

       writeln(zapdvij,'   начальное состояние твердого тела');
       writeln(zapdvij,'   lam0[0]=',lam0[0]:8:5,'   lam0[1]=',lam0[1]:8:5);
       writeln(zapdvij,'   lam0[2]=',lam0[2]:8:5,'   lam0[3]=',lam0[3]:8:5);
       writeln(zapdvij,'   omega0[1]=',omega0[1]:8:5,
       '   omega0[2]=',omega0[2]:8:5,'   omega0[3]=',omega0[3]:8:5);
       writeln(zapdvij,'  конечное состояние твердого тела');
       writeln(zapdvij,'   lamk[0]=',lamk[0]:8:5,'   lamk[1]=',lamk[1]:8:5);
       writeln(zapdvij,'   lamk[2]=',lamk[2]:8:5,'   lamk[3]=',lamk[3]:8:5);
       writeln(zapdvij,'   omegak[1]=',omegak[1]:8:5,
       '   omegak[2]=',omegak[2]:8:5,'   omegak[3]=',omegak[3]:8:5);
       writeln(zapup,'   начальное состояние твердого тела');
       writeln(zapup,'   lam0[0]=',lam0[0]:8:5,'   lam0[1]=',lam0[1]:8:5);
       writeln(zapup,'   lam0[2]=',lam0[2]:8:5,'   lam0[3]=',lam0[3]:8:5);
       writeln(zapup,'   omega0[1]=',omega0[1]:8:5,
       '   omega0[2]=',omega0[2]:8:5,'   omega0[3]=',omega0[3]:8:5);
       writeln(zapup,'  конечное состояние твердого тела');
       writeln(zapup,'   lamk[0]=',lamk[0]:8:5,'   lamk[1]=',lamk[1]:8:5);
       writeln(zapup,'   lamk[2]=',lamk[2]:8:5,'   lamk[3]=',lamk[3]:8:5);
       writeln(zapup,'   omegak[1]=',omegak[1]:8:5,
       '   omegak[2]=',omegak[2]:8:5,'   omegak[3]=',omegak[3]:8:5);
       writeln(zapnev,'   начальное состояние твердого тела');
       writeln(zapnev,'   lam0[0]=',lam0[0]:8:5,'   lam0[1]=',lam0[1]:8:5);
       writeln(zapnev,'   lam0[2]=',lam0[2]:8:5,'   lam0[3]=',lam0[3]:8:5);
       writeln(zapnev,'   omega0[1]=',omega0[1]:8:5,
       '   omega0[2]=',omega0[2]:8:5,'   omega0[3]=',omega0[3]:8:5);
       writeln(zapnev,'  конечное состояние твердого тела');
       writeln(zapnev,'   lamk[0]=',lamk[0]:8:5,'   lamk[1]=',lamk[1]:8:5);
       writeln(zapnev,'   lamk[2]=',lamk[2]:8:5,'   lamk[3]=',lamk[3]:8:5);
       writeln(zapnev,'   omegak[1]=',omegak[1]:8:5,
       '   omegak[2]=',omegak[2]:8:5,'   omegak[3]=',omegak[3]:8:5);
       writeln(zapint,'   начальное состояние твердого тела');
       writeln(zapint,'   lam0[0]=',lam0[0]:8:5,'   lam0[1]=',lam0[1]:8:5);
       writeln(zapint,'   lam0[2]=',lam0[2]:8:5,'   lam0[3]=',lam0[3]:8:5);
       writeln(zapint,'   omega0[1]=',omega0[1]:8:5,
       '   omega0[2]=',omega0[2]:8:5,'   omega0[3]=',omega0[3]:8:5);
       writeln(zapint,'  конечное состояние твердого тела');
       writeln(zapint,'   lamk[0]=',lamk[0]:8:5,'   lamk[1]=',lamk[1]:8:5);
       writeln(zapint,'   lamk[2]=',lamk[2]:8:5,'   lamk[3]=',lamk[3]:8:5);
       writeln(zapint,'   omegak[1]=',omegak[1]:8:5,
       '   omegak[2]=',omegak[2]:8:5,'   omegak[3]=',omegak[3]:8:5);
      {  величины определяющие точность решения задачи  }
       eps:=0.000001;         delta:=0.0000001;
       { предельное число итераций nitk }
       nit:=1;            nitk:=175;
       mnojt:=50;   mnojl:=200;    mnojom:=100;     mnojm:=150;
  { начальное приближение для сопряжённых переменных и времени движения  }
     {  PSKVA(lam0,slam0);             PUMKVA(slam0,lamk,kvape);
       mlam:=sqrt(kvape[1]*kvape[1]+kvape[2]*kvape[2]+kvape[3]*kvape[3]);
       mfi0:=alfa1+alfa2b;
       for ig:=1 to 3 do
           nu00[ig]:=mfi0*kvape[ig]/mlam;
       sinal:=sqrt(1.0-kvape[0]*kvape[0]);
       if abs(kvape[0])>0.000001 then
         kvape[0]:=abs(kvape[0])
           else
             kvape[0]:=0.000001;
       teta:=arctan(sinal/kvape[0]);
               teta:=2.0*teta;
       tk0:=sqrt(4.0*teta/(1.0-sqr(alfa2b/mfi0)));
       cv:=4.0*mfi0/tk0;
       for ig:=1 to 3 do
           p00[ig]:=cv*kvape[ig]/mlam; }
                        {  tk0:=0.962488;}
    {   p00[1]:=-3.149374;         p00[2]:=4.73043;      p00[3]:=-3.569554;
       nu00[1]:=-1.368103;    nu00[2]:=1.456156;   nu00[3]:=-1.665878;     }
       p00[1]:=1.632423080;   p00[2]:=5.550872793;   p00[3]:=-2.281386766;
       nu00[1]:=-0.061210877; nu00[2]:=2.139709164;  nu00[3]:=-1.449145594;
 (*                         tk0:=1.597672264;
   p00[1]:=0.968728232;    p00[2]:=-0.230765069;  p00[3]:=-0.404176917;
   nu00[1]:=0.30410054;    nu00[2]:=0.649908369;   nu00[3]:=0.763144943;*)
       writeln(zapdvij,'    вращение твердого тела ');
       writeln(zapdvij,'t':7,'lam[0]':11,'lam[1]':9,'lam[2]':9,'lam[3]':9,
       'omega[1]':10,'omega[2]':9,'omega[3]':9);
       writeln(zapup,'   управляющие моменты, вращающие тело  ');
       writeln(zapup,'t':7,'mom[1]':11,'mom[2]':9,'mom[3]':9,'modmom':9);
       writeln(zapint,'     первые интегралы ');
       writeln(zapint,'t':7,'int[0]':11,'int[1]':9,'int[2]':9,'int[3]':9);
       { решение краевой задачи методом Ньютона  }     {  goto 3; }
     1:RZCOSHI(0,p00,nu00,nev0);
     writeln(zapnev,'   номер итерации =',nit:3);
     writeln(zapnev,'   начальные значения сопряжённых переменных');
     writeln(zapnev,'    p0[1]=',p00[1]:12:9,'     p0[2]=',p00[2]:12:9);
     writeln(zapnev,'    p0[3]=',p00[3]:12:9,'      tk=',tk:12:9);
     writeln(zapnev,'    nu0[1]=',nu00[1]:12:9,'     nu0[2]=',nu00[2]:12:9);
     writeln(zapnev,'    nu0[3]=',nu00[3]:12:9);
     writeln(zapnev,'   значения невязок ');
    writeln(zapnev,'     nev[1]=',nev0[1]:10:6,'     nev[2]=',nev0[2]:10:6);
    writeln(zapnev,'     nev[3]=',nev0[3]:10:6,'     nev[4]=',nev0[4]:10:6);
    writeln(zapnev,'     nev[5]=',nev0[5]:10:6,'     nev[6]=',nev0[6]:10:6);
  {  writeln(zapnev,'     nev[7]=',nev0[7]:10:6); }
     writeln('   номер итерации =',nit:3);
    writeln('     nev[1]=',nev0[1]:10:6,'     nev[2]=',nev0[2]:10:6);
    writeln('     nev[3]=',nev0[3]:10:6,'     nev[4]=',nev0[4]:10:6);
    writeln('     nev[5]=',nev0[5]:10:6,'     nev[6]=',nev0[6]:10:6);
  {  writeln('     nev[7]=',nev0[7]:10:6);}
     snev0:=0.0;
     for ig:=1 to 6 do snev0:=snev0+sqr(nev0[ig]);
     snev0:=sqrt(snev0);
     writeln(zapnev,'     snev0=',snev0:10:8);    {  goto 3;}
     writeln('     snev0=',snev0:10:8);
     writeln('  PRESS Enter ');
     if  nit mod 5=1 then   readln;
     if ( snev0<eps ) or ( nit>nitk ) then goto 3;
    {   определение производных от невязок   }
     for jg:=1 to 3 do
      begin
      p0v:=p00;   p0v[jg]:=p00[jg]+delta;
     RZCOSHI(0,p0v,nu00,nevv);
     for ig:=1 to 6 do
     anev[ig,jg]:=(nevv[ig]-nev0[ig])/delta;
       end;  {  конец цикла по jg}
     for jg:=1 to 3 do
      begin
      nu0v:=nu00;  nu0v[jg]:=nu00[jg]+delta;
     RZCOSHI(0,p00,nu0v,nevv);
     for ig:=1 to 6 do
     anev[ig,jg+3]:=(nevv[ig]-nev0[ig])/delta;
       end; { цикла по jg }
  {   RZCOSHI(0,1,tk0,p00,nu00,nevv);
     for ig:=1 to 7 do
     anev[ig,7]:=(nevv[ig]-nev0[ig])/(1.0*delta); }
   {    writeln(zapnev,'   матрица производных');
       for ig:=1 to 7 do
       begin
       for jg:=1 to 7 do
       write(zapnev,anev[ig,jg]:10:6);
       writeln(zapnev);
         end;   }
    { определение поправок к начальным значениям сопряжённых переменных
      методом Ньютона }
     for ig:=1 to 6 do nev0[ig]:=-nev0[ig];
     GAUS(6,anev,nev0,gamma);
     sgamma:=0.0;
     for ig:=1 to 6 do sgamma:=sgamma+sqr(gamma[ig]);
     sgamma:=sqrt(sgamma);
     writeln('   sgamma по Гаусу= ',sgamma:10:6); {readln;}
   {  sgamma:=0.3;  }
  {   if ( sgamma>0.25 ) and ( nit mod 2=0 ) then  }
  {   if ( sgamma>0.125 )  then      }
            if ( nit mod 2=0 )  then
     begin           {1  }
     { градиентный метод спуска }
     writeln('   поправки определяются градиентным методом ');
     sgamma:=0.0;
     for ig:=1 to 6 do
      begin
      gamma[ig]:=0.0;
      for jg:=1 to 6 do gamma[ig]:=gamma[ig]+nev0[jg]*anev[jg,ig];
      sgamma:=sgamma+sqr(gamma[ig]);
        end;
     writeln(' координаты вектора -grad(0.5*snev*snev)  ');
     writeln('     gamma[1]=',gamma[1]:10:6,'     gamma[2]=',gamma[2]:10:6);
     writeln('     gamma[3]=',gamma[3]:10:6,'     gamma[4]=',gamma[4]:10:6);
     writeln('     gamma[5]=',gamma[5]:10:6,'     gamma[6]=',gamma[6]:10:6);
   {  writeln('     gamma[7]=',gamma[7]:10:6); }
        sgamma:=sqrt(sgamma);
     {     readln;  }
        for ig:=1 to 6 do  gamma[ig]:=gamma[ig]/sgamma;
     kappa:=0.125;    ndel:=0; upd:=1;
      goto 2;
      end      { 1 }
      else
      begin     { 2 }
     { модификация метода Ньютона }
     writeln('   поправки определены  методом Ньютона');
     writeln('     gamma[1]=',gamma[1]:10:6,'     gamma[2]=',gamma[2]:10:6);
     writeln('     gamma[3]=',gamma[3]:10:6,'     gamma[4]=',gamma[4]:10:6);
     writeln('     gamma[5]=',gamma[5]:10:6,'     gamma[6]=',gamma[6]:10:6);
     writeln('  PRESS Enter');
   {  writeln('     gamma[7]=',gamma[7]:10:6); }
   {  readln;  }
     kappa:=0.5/sgamma;
     if kappa>1.0 then kappa:=1.0;
      ndel:=0;   upd:=1;
       end;     { 2 }
    2:    { tkv:=tk0+gamma[7]*kappa; }
      for ig:=1 to 3 do
      begin
      p0v[ig]:=p00[ig]+gamma[ig]*kappa;
      nu0v[ig]:=nu00[ig]+gamma[ig+3]*kappa;
      end;
      RZCOSHI(0,p0v,nu0v,nevv);
      snevv:=0.0;
      for ig:=1 to 6 do snevv:=snevv+sqr(nevv[ig]);
      snevv:=sqrt(snevv);
  {      writeln('  snevv=',snevv:10:6);}
      {  изменение kappa }
      if upd=1 then
       begin    { 1u }
      if snevv>snev0 then
       begin  { 1  начало оператора if  по snevv }
       kappa:=0.25*kappa;  ndel:=ndel+1;
  {     writeln('  delenie kappa ndel=',ndel:3);  }
        if ndel>45 then
         begin {  2  начало оператора if  по ndel }
       writeln(zapnev,'  решение  остановлено по превышению числа делений');
        goto 3;
         end { 2 }
        else goto 2; { конец  оператора  if  ndel }
          end { 1 }
        else    { if snevv>snev0 }
         begin     { 3  }
         upd:=2;  snevz:=snevv;  kappaz:=kappa;
       kappa:=0.25*kappa;  ndel:=ndel+1;
  {     writeln('  delenie kappa ndel=',ndel:3);    }
        if ndel>45 then
         begin {  2  начало оператора if  по ndel }
       writeln(zapnev,'  решение  остановлено по превышению числа делений');
        goto 3;
        end;  { 2 }
        goto 2;
       end; { 3 }
          end     { 1u }
        else         { if upd=1 }
       begin      { 2u }
       if snevv<snevz then
        begin   { 3 }
    snevz:=snevv;  kappaz:=kappa;
       kappa:=0.25*kappa;  ndel:=ndel+1;
       writeln('  delenie kappa ndel=',ndel:3);
       goto 2;
        end        { 3 }
        else       { if snevv<snevz }
        begin       { 4 }
     {  tk0:=tk0+gamma[7]*kappaz;}
      for ig:=1 to 3 do
      begin
      p00[ig]:=p00[ig]+gamma[ig]*kappaz;
       nu00[ig]:=nu00[ig]+gamma[ig+3]*kappaz;
         end;
         nit:=nit+1; goto 1;
         end;   { 4 }
          end; { 2u  конец оператора if  upd }
      { окончательное решение задачи }
    3: RZCOSHI(1,p00,nu00,nev0);
      close(zapdvij); close(zapint);     close(zapintv);
      close(zapup);  close(zapnev);
  END.









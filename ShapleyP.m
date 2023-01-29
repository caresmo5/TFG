% Esta función de MATLAB calcula los valores de Shapley ponderados de un juego cooperativo de 3 jugadores

function shp = ShapleyP(v,lambda,S1,S2,S3)

% Introducimos la función característica v = [v(1),v(2),...,v(23),v(123)],
% los pesos lambda=[lambda(1),lambda(2),lambda(3)]
% y la partición (por ejemplo, si es P={{2,3},1}, entonces introducimos
% S1=[2,3], S2=[1], S3=[].

% Coaliciones

N=cell(1,7);
N{1}=[1];
N{2}=[2];
N{3}=[3];
N{4}=[1,2];
N{5}=[1,3];
N{6}=[2,3];
N{7}=[1,2,3];

% Partición

P=cell(1,3);
P{1}=S1;
P{2}=S2;
P{3}=S3;

% La fila i-ésima de la matriz A contendrá los valores (Sh_p)_i(N,u_S) para
% las siete posibles coaliciones S

A=zeros(3,7);

for k=1:7   % Una iteración por cada coalición
    
    % Calculamos m = máx{j : P{j} intersectado con N{k} no es vacío}
    % o en la notación del texto, máx{j : Sj intersectado con S no es vacío}
    
    m=0;
    a=intersect(P{1},N{k});
    b=intersect(P{2},N{k});
    c=intersect(P{3},N{k});
    if isempty(c)==0
        m=3;
    elseif isempty(b)==0
        m=2;
    elseif isempty(a)==0
        m=1;        
    end

    w=intersect(N{k},P{m});

    % Calculamos (Sh_p)_i(N,u_S)
    
    for n = 1:3
        if isempty(find(w==n))==1
            A(n,k)=0;
        else
            d=0;
            for j=1:3
                if isempty(find(w==j))==0
                    d=d+lambda(j);
                end
            end
            A(n,k)=lambda(n)/d;
        end
    end
end

%Calculamos los dividendos de Harsanyi

[HD,unanim]=harsanyidividends(v);

% Calculamos el valor de Shapley ponderado para cada jugador

Shp1=0;
for j=1:7
    Shp1=Shp1+HD(j)*A(1,j);
end

Shp2=0;
for j=1:7
    Shp2=Shp2+HD(j)*A(2,j);
end

Shp3=0;
for j=1:7
    Shp3=Shp3+HD(j)*A(3,j);
end

format long
ShP=[Shp1 Shp2 Shp3]

end

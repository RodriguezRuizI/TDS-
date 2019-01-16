% 
%Programaci�n de un v�metro digital
clear
clc
%Estado de los filtros as global
global filterOrder;
global stateLpf;
global stateBpf;
global stateHpf;
global plot_handler_1;
global plot_handler_2_1;
global plot_handler_2_2;
global plot_handler_2_3;
global plot_handler_3;
global N;
global L;

% Datos a tener en cuenta
N = 1024; % Numero de muestras
Fs=8000; % Frecuencia de muestreo
L=1024; % Longitud de los bloques de la se�al de entrada
filterOrder = 256; % Polos del filtro
stateLpf = zeros(1,filterOrder);
stateBpf = zeros(1,filterOrder);
stateHpf = zeros(1,filterOrder);

%Representacion de la se�al original
figure(1);
title('Se�al de entrada')
plot_handler_1 = plot(zeros(1,N));
xlim([0 N-1]);

%Representacion de la se�al filtrada en las diferentes bandas
figure(2);
title('SE�AL FILTRADA')
subplot(3,1,1);
plot_handler_2_1 = plot(zeros(1,2*N));
xlim([0 2*N-1]);
title('Salida del filtro LPF');
xlabel('Frecuencia en Hz');
ylabel('Amplitud');
subplot(3,1,2);
plot_handler_2_2 = plot(zeros(1,2*N));
xlim([0 2*N-1]);
title('Salida del filtro BPF');
xlabel('Frecuencia en Hz');
ylabel('Amplitud');
subplot(3,1,3);
plot_handler_2_3 = plot(zeros(1,2*N));
xlim([0 2*N-1]);
title('salida del filtro HPF');
xlabel('Frecuencia en Hz');
ylabel('Amplitud');

%Reprensentaci�n en gr�fico de barras de la se�al
figure(3);
plot_handler_3 = bar(0);
title('Gr�fico de barras en las tres bandas');
ylim([-60 60])
xlabel('Bandas baja, media y alta');
ylabel('Energ�a de la se�al en dB. Volumen');
daqreset();

% Programaci�n del canal de entrada anal�gica
s=daq.createSession('directsound');               % Se crea una sesi�n
ea=addAudioInputChannel(s, 'Audio1', 2,'Audio');  % Se a�ade un canal de entrada
s.Rate = Fs; % Frecuencia de muestreo
s.IsContinuous=true; % Operation continua
s.NotifyWhenDataAvailableExceeds = L; % Se avisa cuando hay mas de L muestras en la FIFO de entrada

% Listener
lh = addlistener(s,'DataAvailable',@(src,event) callback(event.Data, Fs));

% Comienzo de la operaci�n
startBackground(s);  % Operaci�n en Background
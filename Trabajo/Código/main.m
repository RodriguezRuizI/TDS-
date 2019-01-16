% 
%Programación de un vúmetro digital
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
L=1024; % Longitud de los bloques de la señal de entrada
filterOrder = 256; % Polos del filtro
stateLpf = zeros(1,filterOrder);
stateBpf = zeros(1,filterOrder);
stateHpf = zeros(1,filterOrder);

%Representacion de la señal original
figure(1);
title('Señal de entrada')
plot_handler_1 = plot(zeros(1,N));
xlim([0 N-1]);

%Representacion de la señal filtrada en las diferentes bandas
figure(2);
title('SEÑAL FILTRADA')
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

%Reprensentación en gráfico de barras de la señal
figure(3);
plot_handler_3 = bar(0);
title('Gráfico de barras en las tres bandas');
ylim([-60 60])
xlabel('Bandas baja, media y alta');
ylabel('Energía de la señal en dB. Volumen');
daqreset();

% Programación del canal de entrada analógica
s=daq.createSession('directsound');               % Se crea una sesión
ea=addAudioInputChannel(s, 'Audio1', 2,'Audio');  % Se añade un canal de entrada
s.Rate = Fs; % Frecuencia de muestreo
s.IsContinuous=true; % Operation continua
s.NotifyWhenDataAvailableExceeds = L; % Se avisa cuando hay mas de L muestras en la FIFO de entrada

% Listener
lh = addlistener(s,'DataAvailable',@(src,event) callback(event.Data, Fs));

% Comienzo de la operación
startBackground(s);  % Operación en Background
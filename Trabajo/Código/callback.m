function callback(data,fs)
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

set(plot_handler_1,'YData',data);
% Corta en 850 Hz haciendo las bajas frecuencias
blpf = [0 0.25 0.25 0.588 0.588 1];
mli = [1 1 0 0 0 0];
bli = fir2(filterOrder,blpf,mli);
%freqz(bli,1);
% Corta en 2000 Hz aproximadamente haciendo las frecuencias medias
bbpf = [0 0.25 0.25 0.588 0.588 1];
mpi = [0 0 1 1 0 0];
bpi = fir2(filterOrder,bbpf,mpi);
%freqz(bpi,1);
% hace las frecuencias altas llegando a 3400 Hz
bhpf = [0 0.25 0.25 0.588 0.588 1];
mhi = [0 0 0 0 1 1];
bhi = fir2(filterOrder,bhpf,mhi);
%freqz(bhi,1);
%Filtramos la señal de entrada con los filtros diseñados
[slpf, stateLpf]=filter(bli, 1, data, stateLpf);
[sbpf, stateBpf]=filter(bpi, 1, data, stateBpf);
[shpf, stateHpf]=filter(bhi, 1, data, stateHpf);
%hacemos la fft y el plot de los filtros
fftLpf = fftshift(abs(fft(slpf.*hamming(L),N*2)));
fftBpf = fftshift(abs(fft(sbpf.*hamming(L),N*2)));
fftHpf = fftshift(abs(fft(shpf.*hamming(L),N*2)));
set(plot_handler_2_1,'YData',fftLpf);
set(plot_handler_2_2,'YData',fftBpf);
set(plot_handler_2_3,'YData',fftHpf);

%Cálculo de la energía de las señales
elpf = (1/fs)*sum(abs(slpf.^2));
ebpf = (1/fs)*sum(abs(sbpf.^2));
ehpf = (1/fs)*sum(abs(shpf.^2));
%Definimos los datos que lleva dentro nuestro gráfico de barras y lo
%convertimos en dBs
barsData = [elpf ebpf ehpf];
set(plot_handler_3,'YData',10*log10(barsData));
end


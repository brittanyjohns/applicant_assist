input Key_Vaule = 1.0;
def a = key_vaule;# input(1, title = "Key Vaule. 'This changes the sensitivity'")
input atr_period = 10;
def c = atr_period; # input(10, title = "ATR Period")
input Signals_from_Heikin_Ashi_Candles = no;
def h = signals_from_Heikin_Ashi_Candles; # input(false, title = "Signals from Heikin Ashi Candles")
input show_labels = yes;

def xATR = atr(c);
def nLoss = a * xATR;


def src = if h then (open + high + low + close) / 4 else close;

script nz{
input x = close;
input y = 0;
plot result = if isnan(x) then y else x;
}

#xATRTrailingStop = 0.0
def xATRTrailingStop =compoundValue(1, if(src > nz(xATRTrailingStop[1], 0) and src[1] > nz(xATRTrailingStop[1], 0), max(nz(xATRTrailingStop[1]), src - nLoss),
if(src < nz(xATRTrailingStop[1], 0) and src[1] < nz(xATRTrailingStop[1], 0), min(nz(xATRTrailingStop[1]), src + nLoss),
if(src > nz(xATRTrailingStop[1], 0), src - nLoss, src + nLoss))),0);

#pos = 0
def pos = compoundValue(1, if(src[1] < nz(xATRTrailingStop[1], 0) and src > nz(xATRTrailingStop[1], 0), 1,
if(src[1] > nz(xATRTrailingStop[1], 0) and src < nz(xATRTrailingStop[1], 0), -1, nz(pos[1], 0))) , 0);

def ema = expaverage(src,1);
def above = crosses(ema, xATRTrailingStop, crossingDirection.ABOVE);
def below = crosses(xATRTrailingStop, ema, crossingDirection.ABOVE);

def buy = src > xATRTrailingStop and above ;
def sell = src < xATRTrailingStop and below;

def barbuy = src > xATRTrailingStop ;
def barsell = src < xATRTrailingStop ;

defineglobalColor("Green", color.Green);
defineglobalcolor("Red", color.Red);
addchartbubble(show_labels and buy, low, "B", globalColor("Green"), no);
addchartbubble(show_labels and sell, high, "S", globalColor("Red"), yes);

input price_color_on = yes;
assignPriceColor(if !price_color_on then color.current else if barbuy then globalColor("Green") else color.CURRENT);
assignpriceColor(if !price_color_on then color.current else if barsell then globalColor("Red") else color.currENT);

input alert_sound_on = no;
alert(buy, "UT Long", alert.bar,if alert_sound_on then sound.ring else sound.NoSound);
alert(sell, "UT Short", alert.bar,if alert_sound_on then sound.bell else sound.NoSound);
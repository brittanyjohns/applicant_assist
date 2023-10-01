//@version=4
study(title="VolATR", overlay=true)

atrPeriod = input(20, "Period")
atrMultiplier = input(4, "Multiplier", type=input.float, minval=0.5, maxval=1000, step=0.1)

atr = atr(atrPeriod)
nLoss = atrMultiplier * atr
xATRTrailingStop = float(na)
xATRTrailingStop := iff(close > nz(xATRTrailingStop[1], 0) and close[1] > nz(xATRTrailingStop[1], 0), max(nz(xATRTrailingStop[1]), close - nLoss), iff(close < nz(xATRTrailingStop[1], 0) and close[1] < nz(xATRTrailingStop[1], 0), min(nz(xATRTrailingStop[1]), close + nLoss), iff(close > nz(xATRTrailingStop[1], 0), close - nLoss, close + nLoss)))

pos = int(na)
pos := iff(close[1] < nz(xATRTrailingStop[1], 0) and close > nz(xATRTrailingStop[1], 0), 1, iff(close[1] > nz(xATRTrailingStop[1], 0) and close < nz(xATRTrailingStop[1], 0), -1, nz(pos[1], 0)))

isLong = false
isLong := nz(isLong[1], false)
isShort = false
isShort := nz(isShort[1], false)

LONG = not isLong and pos == 1
SHORT = not isShort and pos == -1

if LONG
    isLong := true
    isShort := false
    isShort

if SHORT
    isLong := false
    isShort := true
    isShort

plotshape(SHORT, title="Sell", style=shape.labeldown, location=location.abovebar, size=size.normal, text="Sell", transp=0, textcolor=color.white, color=color.red)
plotshape(LONG, title="Buy", style=shape.labelup, location=location.belowbar, size=size.normal, text="Buy", textcolor=color.white, color=color.green, transp=0)

len2 = input(20, minval=1, title="Smooth")
src = input(close, title="Source")
out = vwma(src, len2)

vol_length = input(20, "Volume SMA length", minval=1)
vol_avg = sma(volume, vol_length)

unusual_vol_down = volume > vol_avg * 1.2 and close < open
unusual_vol_up = volume > vol_avg * 1.2 and close > open

alertcondition(LONG, "Buy Signal", "Buy Signal")
alertcondition(SHORT, "Sell Signal", "Sell Signal")

###
### Worksheet Exercise 2.3
###

source('setup_data.R', echo = TRUE);

elec.ts    <- ts(CBE.df$elec, start = 1958, freq = 12);
AP.elec.ts <- ts.intersect(AP.ts, elec.ts);

head(AP.elec.ts); tail(AP.elec.ts);

str(AP.elec.ts);

plot(AP.elec.ts);



### Create a plot in ggplot2
#qplot(Var1, value, data = melt(AP.elec.ts), geom = 'line', colour = Var2);

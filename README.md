<h2 align="center">Forecasting Natural Gas Prices with Exogenous Variables</h1>

<p align="center">
  <a href="https://cdna.artstation.com/p/assets/images/images/006/759/716/original/midori-tonbo-flammer2.gif?1501045053" title="Header Gif">
  <img src="https://www.pexels.com/photo/city-road-street-graffiti-3859984/", width="450"/>
  </a>
</p>


## Abstract

Natural gas has quickly become one of the most important fuels of the 21st century. It is the cleanest burning hydrocarbon, an odorless, colorless, and non-toxic gas which has a wide variety of applications. It provides warmth for cooking and heating, and fuels the power stations that provide electricity to homes and businesses. It also is a key input for many industrial processes, such as the manufacturing of glass and clothing, as well as paints, plastics, and fertilizer. 

It has become increasingly adopted by the energy generation sector, natural gas created less than 25% of all electricity in the US in 2011, but today accounts for about 41.1%.

Because of its wide array of uses, natural gas and its corresponding derivatives, or futures contracts, are heavily traded. Commercial buyers and speculators alike seek to identify the true value of natural gas as its price fluctuates. Our approach combines two exogenous variables: degree days, a proxy for demand, and underground storage data, a measure of supply, to build a more comprehensive price prediction model.

This project seeks to forecast natural gas prices two weeks into the future, using the cutting edge Gluon-TS library, a deep learning time series model developed at Amazon. 

## Links

[Presentation](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/presentation/presentation.pdf)<br/>
[Abstract](README.md#Abstract) <br/>
[Data Description](README.md#Data-Description) <br/>
[Price](README.md#Price)<br/>
[Weather](README.md#Weather)<br/>
[Storage](README.md#Storage) <br/>
[SARIMA Model](README.md#SARIMA-Model)<br/>
[Gluon-TS Model](README.md#Gluon-TS-Model)<br/>
[Tuned Gluon-TS Model](README.md#Tuned-Gluon-TS-Model)<br/>
[Future Work](README.md#Future-Work)<br/>
[Summary](README.md#Summary) <br/>

## Data Description

The price data contains the daily spot closing price for natural gas at Louisiana's Henry Hub, one of the most actively traded hubs, sourced from [Quandl](https://www.quandl.com/data/ODA/PNGASUS_USD-Natural-Gas-Natural-Gas-spot-price-at-the-Henry-Hub-terminal-in-Louisiana-US-per-Million-Metric-British-Thermal-Unit).
<p align="center">
  <a href="https://www.quandl.com/data/ODA/PNGASUS_USD-Natural-Gas-Natural-Gas-spot-price-at-the-Henry-Hub-terminal-in-Louisiana-US-per-Million-Metric-British-Thermal-Unit" title="Quandl website">
  <img src="https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/Quandl.png"/>
  </a>
</p>
</br>

The weather data was aggregated from the [National Oceanic and Atmospheric Administration's](https://www.cpc.ncep.noaa.gov/products/analysis_monitoring/cdus/degree_days/) annual degree day database. It contains population weighted HDDs (Heating Degree Days) and CDD (Cooling Degree Days) for the entire continental United States.
<p align="center">
  <a href="https://www.cpc.ncep.noaa.gov/products/analysis_monitoring/cdus/degree_days/" title="NOAA website">
  <img src="https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/NOAA%20logo.png"/>
  </a>
</p>
</br>

The storage data used in this analysis comes from the [Energy Information Administration](https://www.eia.gov/dnav/ng/ng_stor_wkly_s1_w.htm). The data contains 10 years of underground storage information, calculated on a weekly basis, which we interpolate linearly to find daily totals. 
<p align="center">
  <a href="https://www.eia.gov/dnav/ng/ng_stor_wkly_s1_w.htm" title="EIA website">
    <img src="https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/Energy_Information_Administration_logo.png" />
  </a>
</p>

## Price

The price data intially contained all of the closing prices between 1991-2020. Because we are constrained by the storage data, which is limited to the past decade, we decided to focus the scope of the project solely on data between 2011 and 2020. This also coincides nicely with the advent of shale era, which has stabilized prices to a certain degree by expanding the available sources of natural gas.

![price chart](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/historical%20prices.png)

## Weather

Degree days are a measure of the distance from 65°F on a given day. At 65°F, there is very little for heating or cooling. Each 1° deviation from this temperature is counted as a degree day, with values under 65° being HDDs, and values over being CDDs.

Degree days are a good proxy for the demand of natural gas. Temperatures are collected from over 200 major weather stations around the country and used to construct a HDD and CDD value for each day, based on regional population proportionality.

![degree days](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/weather%20combined.png)

Using the historic degree day data to formulate a population-weighted temperature value, we can visualize the aggregate US temperature over the past 9 years. The price of natural gas is most volatile during the summer and winter, especially when the temperature is extreme.

![calendar](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/calendar%20plot.png)

</div>

## Storage

Storage, the supply variable, has a strong seasonality component as well. Storage injections occur during the "shoulder seasons," in the spring and fall, when the weather is most temperate. This is ultimately to prepare for the winter, where large net storage withdrawals are seen.

![storage](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/storage.png)

## SARIMA Model

First, we create a simple SARIMA model to see how it will compare to the Gluon-TS model. We employ the auto_arima package which utilizes a step-wise method to find the optimal p,d, & q values. 

```python
from pmdarima.arima import auto_arima

auto_model = auto_arima(train, start_p=0, start_q=0)

print('Optimal p,d,q: {} x {}'.format(auto_model.order, auto_model.seasonal_order))
```
the auto_arima package determines that 

```python
p,d,q: (2, 1, 1) x (0, 0, 0, 0)
```

are the optimal order values for the model, and we test the fitted model to find that it has a RMSE of 0.1612.

![SARIMA_model](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/SARIMA%20in-sample%20prediction.png)

## Gluon-TS Model

Gluon-TS is a time series modeling toolkit designed to make probabilistic predictions. This means that it creates an ensemble of predictions and uses that distribution to establish a median prediction and confidence interval bands.

</br>

>**“GluonTS simplifies the development of and experimentation with time series models for common tasks such as forecasting or anomaly detection. It provides all necessary >components and tools that scientists need for quickly building new models, for efficiently running and analyzing experiments and for evaluating model accuracy.”**
>
>-GluonTS Arvix [Research Paper](https://arxiv.org/pdf/1906.05264.pdf)

</br>

GluonTS uses a series of LSTM layers to construct the forecasts. LSTM (Long Short-Term Memory) is a type of Recurrent Neural Network, which attempts to address the vanishing gradient problem through a series of 4 gates. These gates utilize a combination of sigmoid and tanh functions to control how much information passes through to the next cell. The sigmoid functions are important to this model, because they are bounded between 0 and 1. They essentially determines how much information is lost or kept during each time step, with a value of "0" rejecting all of the hidden state input, and a value of "1" keeping all of the hidden state input and passing it onto the next cell. </br>

The target variable, "Price", and exogenous variables (what Gluon refers to as "dynamic features") are passed through the first LSTM layer. The output from this layer is concatenated into a single output. This output passes through its own LSTM layer before a single "Price" output is generated.

Below is a basic schema for how the model formulates a single price output.

![schema](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/model-diagram.png)

One of the most difficult parts about using Gluon-TS is adapting the parallel time series data into a format that the model can parse. The ListDataset() method converts the series into a list of dictionaries. 

```python

from gluonts.dataset.common import ListDataset

context_length = 28  #size of rolling window used to create forecast
prediction_length = 14   #size of forecast window
freq= 'D'  #periodicity of forecast points

train_ds = ListDataset([{FieldName.TARGET: full_df['Price'][:-prediction_length],
                         FieldName.FEAT_DYNAMIC_REAL: full_df[['HDD','CDD','Storage']][:-prediction_length].values.T,
                         FieldName.START: full_df.index[0]}],
                         freq=freq)

test_ds = ListDataset([{FieldName.TARGET: full_df['Price'],
                         FieldName.FEAT_DYNAMIC_REAL: full_df[['HDD','CDD','Storage']].values.T,
                         FieldName.START: full_df.index[0]}],
                         freq=freq)


```

Using these 3 inputs converted into the correct format, we are able to generate a sample of 100 predictions.

![all_sample_forecast](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/in-sample%20all%20predictions.png)

From this ensemble of predictions, we can establish a median prediction and confidence intervals.

![in_sample_forecast](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/in-sample%20prediction%20w%20conf_intervals.png)

This model uses default hyperparameters and provides a slightly less robust forecast than the SARIMA model with an RMSE of 0.2254.

By scraping 2 week forecasts for the exogenous variables and appending them to the end of the data, we are able to generate a price forecast for the future window. 

<p align="center">
  <a href="https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/future%20data%20screenshot.png" title="future data">
  <img src="https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/future%20data%20screenshot.png"/>
  </a>
</p>

and ... voila, a two week future price forecast.

![price_forecast](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/future%20forecast%20w%20conf_intervals.png)

## Tuned Gluon-TS Model

Using AWS' SageMaker, we can further improve the model by tuning it's hyperparameters.

The hyperparameters tuned were either IntegerParameters or ContinuousParameters, there were no CategoricalParameters used in the model. Below are the ranges used to tune on SageMaker's hyperparameter tuner:

```python
tuned_hyperparameter_ranges = {
                               'num_cells' : IntegerParameter(30, 200),
                               'num_layers' : IntegerParameter(1, 4),
                               'dropout_rate' : ContinuousParameter(0.0, 0.9),
                               'learning_rate' : ContinuousParameter(1e-5, 0.1)
                               }
```

SageMaker ran 50 different models with various combinations of these hyperparameters and determined the best combination which sought to minimize RMSE. We used this combination of optimal hyperparameters to develop the tuned model below.

```python
from gluonts.model.deepar import DeepAREstimator
from gluonts.mx.trainer import Trainer

estimator_tuned = DeepAREstimator(freq=freq,
                                  num_layers = 4,
                                  num_cells = 44,
                                  cell_type = 'lstm',
                                  context_length=context_length,
                                  prediction_length=prediction_length,
                                  dropout_rate=0.46032325741405156,
                                  use_feat_dynamic_real=True,
                            
                                  trainer=Trainer(epochs=30,
                                                  learning_rate=0.0025475023833545288,
                                                  batch_size=32
                                                  )
                                 )
```
We can test the model to see if accuracy has improved from the tuning.

![tuned_model](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/tuned%20model%20in-sample%20prediction%20w%20conf_intervals.png)

We find that the tuned model has an RMSE of 0.1246, a 44.71% improvement over the default Gluon-TS model!

Using the tuned model, we can create the most accurate future forecast.

![tuned_future](https://github.com/Nick-Kolowich/Forecasting-Natural-Gas-Prices-with-Exogenous-Variables-using-Gluon-TS/blob/main/images/tuned%20model%20future%20forecast%20w%20conf_intervals.png)

## Future Work

We can expand the efficacy of our model by making a few additions.

1. Additional Data
   - incorporate additional exogeneous variables, such as interest rates or trader positioning.

2. Increase Granularity 
   - increase the frequency of the data, examine hourly data instead of daily to improve near term forecasts.

3. Connect to an API
   - add the ability to pull real-time price data from an API, to be able to generate forecasts going forward.

## Summary

The tuned model performed much better than either the Gluon-TS model with default hyperparameters or the SARIMA model. This indicates that Gluon-TS may be better suited for more authentic forecasts and the exogenous variables may have some additional explanatory power about price. Below is each model and it's corresponding RMSE:

<div align="center">

|      |  SARIMA | default Gluon-TS | tuned Gluon-TS |
|------|:------:|:----------------:|:--------------:|
| RMSE | 0.1612 |      0.2253      |     0.1246     |

</div> 

The final Gluon-TS model indicates that the price of natural gas will slightly decline over the next two weeks. It could be profitable to open a short position on natural gas, monitoring any changes to the underlying weather/storage assumptions.

This model was created during the height of winter, the most historically volatile period for natural gas prices. The model's median forecast is fairly stable and does not imply huge volatility in either direction over the next two weeks. 

Energy grid operators could potentially take advantage of this low implied volatility environment by either selling some of their hedges or locking in higher priced delivery contracts if the opportunity arises, given that their costs should remain relatively flat.

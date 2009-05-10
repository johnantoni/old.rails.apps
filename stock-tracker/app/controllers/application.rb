# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

#require 'mysql'
require 'yahoofinance'
#require 'gruff'
#require 'RMagick'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c56be2e4815f5d49ccab7d7c785a09f6'

  before_filter :myConstants

  def myConstants
    #@quote_symbols = "yhoo,goog,msft"
  end

  def scan_light(codes)
    @result = ""
    quotes = YahooFinance::get_standard_quotes(codes)
    quotes.each do |symbol, qt|
      @result = @result + "<li>"    
      @result = @result + "<h3>#{qt.name} [<a href='/reader/single/#{qt.symbol}'>#{qt.symbol}</a>]</h3>"  
      @result = @result + "<p>High: #{qt.dayLow}</p>"
      @result = @result + "<p>Low: #{qt.dayHigh}</p>"
      @result = @result + "<p>Volume: #{qt.volume} (avg #{qt.averageDailyVolume})</p>"
      @result = @result + "<p>Asking price: #{qt.ask}</p>"
      @result = @result + "<p>Last trade: #{qt.lastTradeWithTime}</p>"
      @result = @result + "<p>Day range: #{qt.dayRange}</p>"
      @result = @result + "<p>Change: #{qt.changePercent}</p>"
      @result = @result + "<p>Time: #{qt.date} #{qt.time}</p>"
      @result = @result + "<p>Trend: #{qt.tickerTrend} (+up =stand -down)</p>"
      @result = @result + "<p>Change points: #{qt.changePoints}</p>"
      @result = @result + "<p>Change: #{qt.change}</p>"
      @result = @result + "<p>Opened at: #{qt.open}</p>"
      @result = @result + "<p>Previous close: #{qt.previousClose}</p>"
      @result = @result + "<p>Last trade: #{qt.lastTrade}</p>"
      @result = @result + "</li>"    
    end    
    scan_light = @result
  end

  def scan_full(codes)
    @result = ""
    quotes = YahooFinance::get_extended_quotes(codes)
    quotes.each do |symbol, qt|
      @result = @result + "<li>"    
      @result = @result + "<h3>Extended Data: #{qt.name} [<a href='/reader/single/#{qt.symbol}'>#{qt.symbol}</a>]</h3>"
      @result = @result + "<p>moving avg 50 days change: #{qt.movingAve50daysChangePercentFrom}</p>"
      @result = @result + "<p>52 weeks change from low: #{qt.weeks52ChangeFromLow}</p>"
      @result = @result + "<p>annualized gain: #{qt.annualizedGain}</p>"
      @result = @result + "<p>price paid: #{qt.pricePaid}</p>"
      @result = @result + "<p>52 weeks from low: #{qt.weeks52ChangePercentFromLow}</p>"
      @result = @result + "<p>52 weeks range: #{qt.weeks52Range}</p>"
      @result = @result + "<p>stock exchange: #{qt.stockExchange}</p>"
      @result = @result + "<p>holdings gain: #{qt.holdingsGain}</p>"
      @result = @result + "<p>trade date: #{qt.tradeDate}</p>"
      @result = @result + "<p>peg ratio: #{qt.pegRatio}</p>"
      @result = @result + "<p>dividend yield: #{qt.dividendYield}</p>"
      @result = @result + "<p>day change: #{qt.dayValueChange}</p>"
      @result = @result + "<p>price per EPS est. curr year: #{qt.pricePerEPSEstimateCurrentYear}</p>"
      @result = @result + "<p>one-year target price: #{qt.oneYearTargetPrice}</p>"
      @result = @result + "<p>dividend per share: #{qt.dividendPerShare}</p>"
      @result = @result + "<p>short ratio: #{qt.shortRatio}</p>"
      @result = @result + "<p>holdings value: #{qt.holdingsValue}</p>"
      @result = @result + "<p>commission: #{qt.commission}</p>"
      @result = @result + "<p>price per sale: #{qt.pricePerSales}</p>"
      @result = @result + "<p>price EPS estimate next year: #{qt.pricePerEPSEstimateNextYear}</p>"
      @result = @result + "<p>earnings per share: #{qt.earningsPerShare}</p>"
      @result = @result + "<p>notes: #{qt.notes}</p>"
      @result = @result + "<p>high limit: #{qt.highLimit}</p>"
      @result = @result + "<p>moving avg 50 days: #{qt.movingAve50days}</p>"
      @result = @result + "<p>price per book: #{qt.pricePerBook}</p>"
      @result = @result + "<p>ex. dividend date: #{qt.exDividendDate}</p>"
      @result = @result + "<p>low limit: #{qt.lowLimit}</p>"
      @result = @result + "<p>moving avg 200 days: #{qt.movingAve200days}</p>"
      @result = @result + "<p>book value: #{qt.bookValue}</p>"
      @result = @result + "<p>eps est. current year: #{qt.epsEstimateCurrentYear}</p>"
      @result = @result + "<p>market cap: #{qt.marketCap}</p>"
      @result = @result + "<p>pe ratio: #{qt.peRatio}</p>"
      @result = @result + "<p>shares owned: #{qt.sharesOwned}</p>"
      @result = @result + "<p>moving avg 200 days change from: #{qt.movingAve200daysChangeFrom}</p>"
      @result = @result + "<p>eps est. next year: #{qt.epsEstimateNextYear}</p>"
      @result = @result + "<p>moving avg 200 days change percent from: #{qt.movingAve200daysChangePercentFrom}</p>"
      @result = @result + "<p>eps est. next quarter: #{qt.epsEstimateNextQuarter}</p>"
      @result = @result + "<p>dividend pay date: #{qt.dividendPayDate}</p>"
      @result = @result + "<p>52 weeks change from high: #{qt.weeks52ChangeFromHigh}</p>"
      @result = @result + "<p>holdings gain percent: #{qt.holdingsGainPercent}</p>"
      @result = @result + "<p>moving avg. 50 days change from: #{qt.movingAve50daysChangeFrom}</p>"
      @result = @result + "<p>ebitda: #{qt.ebitda}</p>"
      @result = @result + "<p>52 weeks change percent from high: #{qt.weeks52ChangePercentFromHigh}</p>"
      @result = @result + "</li>"    
    end    
    scan_full = @result
  end

  def scan_history(codes)
    @result = ""
    @result = @result + "<li>"    
    @result = @result + "<h3>History [2 years]</h3>"    
    YahooFinance::get_HistoricalQuotes(codes, Date.today()<<24, Date.today()) do |hq|
      @result = @result + "<p>#{hq.date}, O #{hq.open}, H #{hq.high}, L #{hq.low}, C #{hq.close}, V #{hq.volume}, A #{hq.adjClose}</p>"
    end    
    @result = @result + "</li>"

    scan_history = @result
  end

end

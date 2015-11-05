require 'sinatra'
#require 'sinatra/streaming'
require 'yahoofinance'

post '/stock/:symbol', provides: 'text/event-stream' do
    stream :keep_open do |out|
        # Error handling code omitted
        out << ": hello\n\n" unless out.closed?
        loop do
            quote = YahooFinance::Quote.new(YahooFinance::RealTimeQuote, [params[:symbol]])
            if quote
                data = quote.results(:to_hash).output
                out << "data:{\"price\":\"#{data.last_trade_price_only}\",\"time\":\"#{data.last_trade_date}\"}\n\n"
            else
                out << ": heartbeat\n\n" unless out.closed?
                sleep 1
            end
        end
    end
end

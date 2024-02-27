START_YEAR = 1923
END_YEAR = 2024

STOCK = []

class Stock
    attr_accessor :name, :built, :traction, :operators, :y, :based_on, :wiki

    def initialize(name)
        @name = name
        @operators ||= []
        @y = 0
        @based_on ||= []
        @wiki = "British Rail Class #{name}"
    end
end

class StockDSL
    def initialize(stock)
        @stock = stock
    end

    def built(range)
        if range.is_a? Integer
            range = range..range
        end
        @stock.built = range
    end

    def traction(*types)
        @stock.traction = types
    end

    def operator(operator, years)
        if operator == :br && years.end > 1982
            STDERR.puts "#{@stock.name}: sectorize!"
        end
        @stock.operators << [operator, years]
    end
    
    def wiki(x)
        @stock.wiki = x
    end

    def y(y)
        @stock.y = y
    end

    def yf(other)
        other = other.to_s
        from_stock = STOCK.find { |s| s.name == other }
        from_y = if from_stock.built.end < @stock.built.begin
            from_stock.y
        else
            from_stock.y + 1
        end
        @stock.y = [@stock.y, from_y].max
    end

    def yo(o)
        @stock.y += o
    end

    def based_on(other, **options)
        other = other.to_s
        @stock.based_on << [other, options]

        yf other
    end

    def make(*x)
    end
end

# makes:
# birmingham_rcw: Birmingham Railway Carriage and Wagon Company
# birmingham: Metro-Cammell and Alstom at former M-C works
# ucc: Union Construction Company
# gloucester: Gloucester Railway Carriage and Wagon Company
# leeds_forge: Leeds Forge Company
# derby: Derby Works, incl BREL and Adtranz/Bombarider/Alstom

def stock(name, &block)
    s = Stock.new(name.to_s)
    StockDSL.new(s).instance_eval(&block)
    STOCK << s
end

stock "G Stock" do
    built 1923
    traction :fourth_rail
    operator :lu, 1923..1971
    wiki "London Underground G Stock"
    make :gloucester
    y 1
end

stock "Standard Stock" do
    built 1923..1934
    traction :fourth_rail
    operator :lu, 1923..1964
    wiki "London Underground Standard Stock"
    make :birmingham_rcw, :birmingham, :ucc, :gloucester, :leeds_forge
end

stock "K Stock" do
    built 1927
    traction :fourth_rail
    operator :lu, 1923..1971
    wiki "London Underground K Stock"
    make :birmingham

    y 2
end

stock "L Stock" do
    built 1932
    traction :fourth_rail
    operator :lu, 1932..1971 # wiki's weird here
    wiki "London Underground L Stock"
    based_on "K Stock"
    make :ucc
    
    y 2
end

stock "M Stock" do
    built 1935
    traction :third_rail
    operator :lu, 1935..1971
    wiki "London Underground M Stock"
    based_on "L Stock" # wiki says K, unclear
    make :birmingham_rcw
    y 2
end

stock "N Stock" do
    built 1935
    traction :third_rail
    operator :lu, 1935..1971
    wiki "London Underground M Stock"
    based_on "L Stock"# wiki says K, unclear
    make :birmingham
    y 3
end

stock 403 do
    built 1932
    traction :third_rail
    operator :br, 1932..1972
    make :birmingham

    y 1
end

stock "1935 Stock" do
    built 1935
    traction :fourth_rail
    operator :lu, 1936..1976
    based_on "Standard Stock"
    make :birmingham
    wiki "London Underground 1935 Stock"
    y 1
end

stock 401 do
    built 1935..1938
    traction :third_rail
    operator :br, 1935..1971
    make :eastleigh, :lancing

    y 8
end

stock 404 do
    # TODO: any relation to 401?

    built 1937..1938
    traction :third_rail
    operator :br, 1937..1972
    make :eastleigh, :lancing

    y 19
end

stock "1938 Stock" do
    built 1937..1940
    traction :fourth_rail
    operator :lu, 1938..1988
    based_on "1935 Stock"
    wiki "London Underground 1938 Stock"
    make :birmingham_rcw, :birmingham
    y 1
end

stock "O Stock" do
    built 1937 # rough
    traction :fourth_rail
    operator :lu, 1937..1981
    wiki "London Underground O Stock"
    make :gloucester, :birmingham_rcw
    y 13
end

stock 402 do
    built 1938..1939
    traction :third_rail
    operator :br, 1939..1971
    based_on 401
    make :eastleigh, :lancing
    y 9
end

stock 503 do
    built 1938..1953
    traction :third_rail
    operator :br, 1938..1982
    operator :rr, 1982..1985
    based_on "O Stock"
    make :birmingham, :birmingham_rcw
    yo 1
end

stock 502 do
    built 1939..1941
    traction :third_rail
    operator :br, 1939..1980
    based_on 503, start_socket: :bottom, end_socket: :left, start_x: 10
    make :derby
end

stock "P Stock" do
    built 1939 # rough
    traction :fourth_rail
    operator :lu, 1937..1981
    based_on "O Stock"
    wiki "London Underground P Stock"
    make :gloucester, :birmingham_rcw
end

stock "Q38 Stock" do
    built 1939
    traction :fourth_rail
    operator :lu, 1939..1971
    wiki "London Underground Q38 Stock"
    make :gloucester

    y 5
end

stock 487 do
    built 1940
    traction :fourth_rail
    operator :br, 1940..1982
    operator :nse, 1982..1993
    make :english_electric

    y 4
end

stock 405 do
    # 4SUB
    # complicated - I think this might be a "various old stuff"
    # designation?
    built 1941..1951
    traction :third_rail
    operator :br, 1941..1982
    operator :nse, 1982..1983
    make :eastleigh, :lancing
    y 21
end

stock "402 (steel)" do
    # all-steel 2HAL
    # https://www.bloodandcustard.com/SR-2HAL.html#Steel
    # TODO do we count the very last one several years later
    built 1948
    traction :third_rail
    operator :br, 1948..1971
    make :eastleigh
    based_on 405
end

stock 306 do
    built 1949
    traction :ole1500, :ole25kv
    operator :br, 1949..1981
    make :birmingham, :birmingham_rcw
    y 8
end

stock "R Stock" do
    built 1949 #?
    traction :fourth_rail
    operator :lu, 1949..1983
    make :birmingham_rcw, :gloucester
    based_on "Q38 Stock"
end

stock 506 do
    built 1950
    traction :ole1500
    operator :br, 1954..1982
    operator :rr, 1982..1984
    make :birmingham, :birmingham_rcw
    based_on 306
    y 9
end

stock "Mark 1" do
    built 1951..1963
    traction :hauled
    operator :br, 1951..1982
    operator :nse, 1982..1994
    operator :rr, 1982..1997
    operator :ic, 1982..1994
    operator :first_nw, 1997..2000
    operator :anglia, 1997..2000
    operator :nx_scotrail, 1997..2000
    make :br, :cravens, :gloucester

    y 4
end

stock "415/1" do
    # 4EPB (SR design)
    # https://www.bloodandcustard.com/sR-4epb.html
    built 1951..1957
    traction :third_rail
    operator :br, 1951..1982
    operator :nse, 1982..1995
    make :eastleigh
    based_on 405, start_socket: :bottom, start_x: 950
end

stock "416/1" do
    # 2 EPB (SR design)
    built 1953..1956
    traction :third_rail
    operator :br, 1955..1982
    operator :nse, 1982..1995 # priv?
    make :eastleigh, :ashford, :lancing
    # based_on 2NOL
    y 27
end

stock 307 do
    built 1954..1956
    traction :ole25kv
    operator :br, 1956..1982
    operator :nse, 1982..1991
    operator :rr, 1991..1993
    make :eastleigh
    y 26
end

stock "415/2" do
    # 4EPB (BR)
    # https://www.bloodandcustard.com/BR-4epb.html
    built 1960..1963
    traction :third_rail
    operator :br, 1951..1982
    operator :nse, 1982..1995
    make :eastleigh
    based_on "Mark 1", start_socket: :bottom, start_x: 850
end

stock "416/2" do
    built 1954..1955 # tyneside; unclear if there were others
    traction :third_rail
    operator :br, 1955..1982
    operator :nse, 1982..1955 #priv?
    make :eastleigh
    based_on "Mark 1", start_x: 250, start_socket: :bottom
    yo 3
end

stock 129 do
    built 1955 # tyneside; unclear if there were others
    traction :diesel
    operator :br, 1958..1973
    make :cravens
    y 24
end

stock 501 do
    built 1955..1956
    traction :fourth_rail, :third_rail
    operator :br, 1957..1982
    operator :nse, 1982..1985
    make :eastleigh
    based_on "415/1"
end

stock 101 do
    # incl former 102
    built 1956..1960
    traction :diesel
    operator :br, 1956..1982
    operator :nse, 1982..1996
    operator :rr, 1982..1997
    operator :first_nw, 1997..2003
    make :birmingham
    y 37
end

stock 105 do
    # incl former 106
    built 1956..1959
    traction :diesel
    operator :br, 1959..1982
    operator :nse, 1982..1988
    make :cravens
    based_on "Mark 1", end_socket: :left, start_x: 250
    y 21
end

stock 114 do
    # Derby Heavyweight based
    built 1956..1957
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1991
    make :derby
    y 24
end

stock 411 do
    built 1956..1963
    traction :third_rail
    operator :br, 1956..1982
    operator :nse, 1982..1996
    operator :connex_sc, 1996..1998
    operator :connex_se, 1996..2003
    operator :swt, 1996..2004
    operator :set, 2003..2005
    based_on "Mark 1", start_socket: :bottom, start_x: 250
    based_on 404, start_socket_gravity: 2000
    make :eastleigh
end

stock 100 do
    built 1956..1958
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1988 #?
    make :gloucester
    y 40
end

stock "1956 Stock" do
    built 1956
    traction :fourth_rail
    operator :lu, 1957..1995
    make :birmingham, :birmingham_rcw, :gloucester
    based_on "1938 Stock"
    yo 2
end

stock 103 do
    built 1957 #?
    traction :diesel
    operator :br, 1957..1982
    operator :rr, 1982..1983
    make :park_royal
    y 42
end

stock 104 do
    built 1957..1959
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1995
    operator :rr, 1982..1990
    make :birmingham_rcw
    y 39
end

stock "414/2" do
    # 2 HAP (BR)
    built 1957..1963
    traction :third_rail
    operator :br, 1556..1982
    operator :nse, 1982..1955
    based_on "416/2"
    make :eastleigh

    yo 1
end

stock 109 do
    built 1957..1958
    traction :diesel
    operator :br, 1957..1971
    make :d_wickham
    y 41
end

stock 111 do
    built 1957..1960
    traction :diesel
    operator :br, 1957..1982
    operator :rr, 1982..1989
    make :birmingham
    based_on 101, start_x: 50, start_socket: :bottom
end

stock 116 do
    built 1957..1961
    traction :diesel
    operator :br, 1961..1982
    operator :nse, 1982..1995 # approx
    operator :rr, 1982..1995 # approx
    make :derby
    based_on 114
end

stock 201 do
    built 1957..1958
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1986
    make :eastleigh, :ashford
    based_on "Mark 1", start_x: 550, start_socket: :bottom
    yo 2
end

stock 202 do
    built 1957..1958
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1986
    make :eastleigh, :ashford
    based_on "Mark 1", start_x: 550, start_socket: :bottom
end

stock 204 do
    # 2H
    built 1957..1958
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1987
    make :eastleigh
    based_on "414/2", end_socket: :left, start_socket: :left, start_x: 0, start_y: "75%"
end

stock 205 do
    # 3H
    built 1959..1962
    traction :diesel
    operator :br, 1959..1982
    operator :nse, 1982..1996
    operator :connex_sc, 1996..2004
    make :eastleigh
    based_on 204
    yo 1
end

stock 203 do
    built 1958
    traction :diesel
    operator :br, 1957..1982
    operator :nse, 1982..1986
    make :eastleigh, :ashford

    based_on 202
end

stock "414/1" do
    built 1958
    traction :third_rail
    operator :br, 1556..1982
    operator :nse, 1982..1995
    # based_on 2NOL
    make :eastleigh
    y 34
end

stock 120 do
    built 1957..1960
    traction :diesel
    operator :br, 1958..1982
    operator :rr, 1982..1989
    make :swindon
    y 35
end

stock 119 do
    built 1958
    traction :diesel
    operator :br, 1958..1982
    operator :nse, 1982..1992
    make :gloucester
    based_on 120, start_x: 50, start_socket: :bottom
end

stock 108 do
    built 1958..1961
    traction :diesel
    operator :br, 1958..1982
    operator :nse, 1982..1993
    operator :rr, 1982..1993
    # based_on derby lightweight
    make :derby
    y 42
end

stock 125 do
    built 1958..1959
    traction :diesel
    operator :br, 1959..1977
    based_on 116, start_x: 50, start_socket: :bottom, end_socket: :left
    make :derby

    yo 6
end

stock 302 do
    built 1958..1959
    traction :ole25kv
    operator :br, 1958..1982
    operator :nse, 1982..1996
    operator :lts, 1996..1998
    based_on "Mark 1", end_socket: :left, start_x: 550
    make :york, :doncaster
    yo 7
end

stock "410 and 412" do
    # 4BEP
    built 1958..1961
    traction :third_rail
    operator :br, 1956..1982
    operator :nse, 1982..1996
    operator :swt, 1996..2005
    based_on 411, start_x: 50, start_socket: :bottom
    wiki "British Rail Class 411"
    make :eastleigh
end

stock 112 do
    built 1959..1960
    traction :diesel
    operator :br, 1960..1969
    based_on 105, start_socket: :bottom, start_x: 210
    make :cravens
end

stock 113 do
    built 1959..1960
    traction :diesel
    operator :br, 1960..1969
    based_on 105, start_socket: :bottom, start_x: 210
    make :cravens
    yo 1
end

stock 117 do
    built 1959..1961
    traction :diesel
    operator :br, 1959..1982
    operator :nse, 1982..1996
    operator :silverlink, 1996..2000
    make :pressed_steel
    based_on 116, start_x: 50, start_socket: :bottom
    yo 4
end

stock 122 do
    built 1958
    traction :diesel
    operator :br, 1958..1982
    operator :nse, 1982..1995
    operator :rr, 1982..1995
    based_on 116, end_socket: :top, start_x: 145
    make :gloucester
    yo 1
end

stock 126 do
    built 1959..1960
    traction :diesel
    operator :br, 1959..1982
    operator :rr, 1982..1983
    make :swindon
    # based_on "1955 Swindon E&G trains"
    y 33
end

stock 127 do
    built 1958..1959
    traction :diesel
    operator :br, 1959..1982
    operator :nse, 1982..1993
    make :derby
    # sources say "standard derby design" - presumably
    # this means the 116
    based_on 116, start_x: 50, start_socket: :bottom
    yo 5
end

stock 128 do
    built 1959..1960
    traction :diesel
    operator :br, 1959..1982
    operator :res, 1982..1990
    make :gloucester
    # sources say "standard derby design" - presumably
    # this means the 116
    based_on 116, start_x: 50, start_socket: :bottom
    yo 3
end

stock "Blue Pullman" do
    built 1959..1960
    traction :diesel
    operator :br, 1960..1973
    make :birmingham
    wiki "Blue Pullmans"
    y 40
end

stock "1959 Stock" do
    built 1959 #?
    traction :fourth_rail
    operator :lu, 1959..2000
    make :birmingham
    wiki "London Underground 1959 Stock"
    based_on "1956 Stock"
end

stock 303 do
    built 1959..1961
    traction :ole25kv
    operator :br, 1960..1982
    operator :rr, 1982..1996
    operator :nx_scotrail, 1996..2002
    make :pressed_steel
    based_on 302, start_x: 50, start_socket: :bottom #?
end

stock 305 do
    built 1959..1960
    traction :ole25kv
    operator :br, 1959..1982
    operator :nse, 1982..1996
    operator :rr, 1982..1996
    operator :first_nw, 1996..2000
    operator :nx_scotrail, 1996..2001
    make :york, :doncaster
    based_on 302, start_x: 50 #?
    yo 2
end

stock 308 do
    built 1959..1961
    traction :ole25kv
    operator :br, 1959..1982
    operator :nse, 1982..1989 #?
    operator :rr, 1982..1996
    operator :res, 1983..1992
    operator :arriva_northern, 1996..2001
    make :york
    based_on 302, start_x: 50 #?
    yo 3
end

stock 419 do
    built 1959..1961
    traction :third_rail, :battery
    operator :br, 1959..1982
    operator :nse, 1982..1992
    make :eastleigh
    based_on "Mark 1", end_socket: :left, start_x: 550
    yo 13
end

stock 504 do
    built 1959..1961
    traction :third_rail_side
    operator :br, 1959..1982
    operator :rr, 1982..1991
    make :wolverton
    based_on 302, start_x: 50 #?
    yo 4
end

stock 107 do
    built 1960
    traction :diesel
    operator :br, 1960..1982
    operator :rr, 1982..1991
    make :derby
    based_on 116
end

stock 115 do
    built 1960
    traction :diesel
    operator :br, 1960..1982
    operator :nse, 1982..1996
    operator :chiltern, 1996..1998
    make :derby
    based_on 127, end_socket: :top
    yo 1
end

stock 118 do
    built 1960
    traction :diesel
    operator :br, 1960..1982
    operator :nse, 1982..1994
    make :birmingham_rcw
    based_on 116
    
    yo 1
end

stock 121 do
    # TODO link to 117? same depot, railcar thinks it's related
    # - but the most obvious link is to the other bubble car
    built 1960..1961
    traction :diesel
    operator :br, 1960..1982
    operator :rr, 1982..1995 #?
    operator :nse, 1982..1996
    operator :silverlink, 1996..2001
    operator :arriva_wales, 2006..2013
    operator :chiltern, 2003..2017
    # FGE borrowed 121s, 150s and 153s
    make :pressed_steel
    based_on 122
    yo 1
end

stock 124 do
    built 1960
    traction :diesel
    operator :br, 1960..1982
    operator :rr, 1982..1984
    make :swindon
    based_on 126, start_x: 50, start_socket: :bottom # also 303 windows, but ughhhh

    # TODO apparently 123 and 124 have some mk1 dna
end

stock 304 do
    built 1960..1961
    traction :ole25kv
    operator :br, 1960..1982
    operator :rr, 1982..1996
    make :wolverton
    based_on 302, start_x: 50, start_socket: :bottom #?
    yo 2
end

stock "1960 Stock" do
    built 1960
    traction :fourth_rail
    operator :lu, 1960..1994
    make :cravens
    based_on "Standard Stock"
    yo 1
end

stock "A60 and A62 Stock" do
    built 1960..1962
    traction :fourth_rail
    operator :lu, 1961..2012
    based_on "1938 Stock"
    yo 1
end

stock 110 do
    built 1961..1962
    traction :diesel
    operator :br, 1961..1982
    operator :rr, 1982..1991
    make :birmingham_rcw
    based_on 104
end

stock 207 do
    # 3D
    built 1962
    traction :diesel
    operator :br, 1962..1982
    operator :nse, 1982..1996
    operator :connex_sc, 1996..2001
    operator :southern, 2001.2004
    make :eastleigh
    based_on 205, end_socket: :left, start_socket: :bottom
end

stock 309 do
    built 1962..1963 # ignores some extra coaches
    traction :ole25kv
    operator :br, 1963..1982
    operator :nse, 1982..1994
    operator :rr, 1994..1996
    operator :first_nw, 1996..2000
    make :york, :wolverton
    based_on 303, end_socket: :top
    yo 1
end

stock "1962 Stock" do
    built 1962
    traction :fourth_rail
    operator :lu, 1962..1999
    make :birmingham, :derby
    based_on "1959 Stock"
    wiki "London Underground 1962 Stock"
end

stock 123 do
    built 1962
    traction :diesel
    operator :br, 1963..1982
    operator :rr, 1982..1984
    make :swindon
    based_on 124
end

stock 206 do
    built 1964
    traction :diesel
    operator :br, 1964..1982
    operator :nse, 1982..1990 #ish
    based_on 201
    based_on "416/2"
end

stock "Mark 2" do
    built 1963..1975
    traction :hauled
    operator :br, 1964..1982
    operator :nse, 1982..1996
    operator :rr, 1982..1996
    operator :ic, 1982..1996
    operator :virgin_xc, 1996..2002
    operator :virgin_wc, 1996..2003
    operator :anglia, 1996..2004
    operator :wessex, 2002..2006
    operator :nxea, 2004..2006
    operator :arriva_northern, 2003..2004
    operator :first_gw, 1996..2010
    operator :first_scotrail, 2008..2015
    operator :serco_abellio_northern, 2004..2016
    operator :northern, 2016..2018
    operator :caledonian_sleeper, 2015..2019
    operator :scotrail, 2015..2020
    make :derby
    y 6
end

stock 421 do
    # 4 CIG
    built 1964..1972
    traction :third_rail
    operator :br, 1964..1982
    operator :nse, 1982..1996
    operator :connex_sc, 1996..2000
    operator :set, 1996..2004
    operator :southern, 2000..2005
    operator :swt, 1996..2010
    based_on 411
    make :york
    yo 1
end

stock 310 do
    built 1965..1967
    traction :ole25kv
    operator :br, 1965..1982
    operator :nse, 1982..1996
    operator :rr, 1982..1996
    operator :lts, 1996..2000
    operator :c2c, 2000..2002
    operator :central, 1996..2002
    make :derby
    based_on "Mark 2", start_socket: :bottom, start_x: 150
end

# TODO: 131? meh

stock 311 do
    built 1966..1967
    traction :ole25kv
    operator :br, 1967..1982
    operator :rr, 1982..1990
    make :cravens
    based_on 303
end

stock 438 do
    # Mk1s with cabs but no traction
    built 1966..1967
    traction :hauled
    operator :br, 1966..1982
    operator :nse, 1982..1989
    make :york
    # blood and custard: similar cabs
    based_on 421, start_x: 150, start_socket: :bottom
end

stock 432 do
    # 4 REP: 438s with motors
    built 1966..1967
    traction :third_rail
    operator :br, 1966..1982
    operator :nse, 1982..1992
    make :york
    based_on 421, start_x: 150
    yo 1
end

stock 423 do
    built 1967..1974
    traction :third_rail
    operator :br, 1967..1982
    operator :nse, 1982..1996
    operator :connex_sc, 1996..2000
    operator :connex_se, 1996..2003
    operator :swt, 1996..2005
    operator :set, 2003..2005
    operator :southern, 2000..2005
    based_on 421, start_x: 150
    make :york, :derby
    yo 2
end

stock "485 and 486" do
    built 1966..1967
    traction :third_rail
    operator :br, 1967..1982
    operator :nse, 1982..1992
    make :birmingham, :ucc
    based_on "Standard Stock"
end

stock "1967 Stock" do
    built 1967..1969
    traction :fourth_rail
    operator :lu, 1968..2011
    make :birmingham
    based_on "1960 Stock"
    wiki "London Underground 1967 Stock"
end

stock 418 do
    built 1974..1982
    traction :third_rail
    operator :br, 1974..1982
    based_on "414/2"
    yo 1
end

stock "C69 Stock" do
    built 1969
    traction :fourth_rail
    operator :lu, 1970..2014
    # tubeprune: similar cab
    wiki "London Underground C69 Stock"
    based_on "1967 Stock", start_socket: :bottom
    make :birmingham
    yo 1
end

stock "C77 Stock" do
    built 1977
    traction :fourth_rail
    operator :lu, 1970..2014
    wiki "London Underground C77 Stock"
    based_on "C69 Stock"
    make :birmingham
    yo 1
end

stock "445 & 446" do
    built 1971
    traction :third_rail
    operator :br, 1971..1980
    make :york

    y 5
end

stock "1972 Stock" do
    built 1972..1974
    traction :fourth_rail
    operator :lu, (1972..)
    make :birmingham
    wiki "London Underground 1972 Stock"
    based_on "1967 Stock"
end

stock "1973 Stock" do
    built 1974..1977
    traction :fourth_rail
    operator :lu, (1975..)
    make :birmingham
    wiki "London Underground 1973 Stock"
    # tubeprune: similar cabs
    based_on "1972 Stock"
    based_on "C69 Stock"
end

stock "Mark 3A" do
    built 1975..1988
    traction :hauled
    operator :br, 1975..1982
    operator :ic, 1982..1996
    operator :nxea, 2002..2012
    operator :virgin_wc, 1996..2014
    operator :first_gw, 1996..2015
    operator :arriva_wales, 2012..2018
    operator :ga, 2014..2020
    operator :tfw, 2018..2020
    operator :gwr, (2015..)
    operator :chiltern, (2012..)
    make :derby

    y 11
end

stock "HST" do
    built 1975..1982
    traction :diesel
    operator :br, 1975..1982
    operator :ic, 1982..1996
    operator :virgin_wc, 1996..2003
    operator :virgin_xc, 1996..2004
    operator :gner, 1996..2007
    operator :mml, 1996..2007
    operator :nxec, 2007..2009
    operator :ec, 2009..2015
    operator :first_gw, 1996..2015
    operator :grand_central, 2007..2017
    operator :virgin_ec, 2015..2018
    operator :lner, 2018..2019
    operator :hull_trains, 2019..2019
    operator :stagecoach_em, 2007..2019
    operator :emr, 2019..2021
    operator :xc, 2007..2023
    operator :gwr, (2015..)
    operator :scotrail, (2018..)
    make :derby
    based_on "Mark 3A"
end

stock 312 do
    built 1975..1978
    traction :ole25kv
    operator :br, 1975..1982
    operator :nse, 1982..1996
    operator :rr, 1982..1996
    operator :central, 1996..1996
    operator :first_ge, 1996..2004
    operator :lts, 1996..2000
    operator :c2c, 2000..2003
    make :york
    based_on 310
end

stock 313 do
    built 1976..1977
    traction :ole25kv, :third_rail
    operator :br, 1976..1982
    operator :nse, 1982..1996
    operator :wagn, 1996..2006
    operator :silverlink, 1996..2007
    operator :lo, 2007..2010
    operator :fcc, 2006..2014
    operator :gn, 2014..2019
    operator :southern, 2010..2023
    make :york
    based_on "445 & 446"
end

stock 507 do
    built 1978..1980
    traction :third_rail
    operator :br, 1978..1982
    operator :rr, 1982..1996
    operator :merseyrail, (1996..)
    make :york
    based_on 313
    yo 1
end

# reserved

stock 413 do
    built 1982
    traction :third_rail
    operator :nse, 1982..1995
    make :eastleigh
    based_on "414/2"
end

stock 483 do
    built 1989..1992
    traction :third_rail
    operator :nse, 1989..1996
    operator :stagecoach_il, 1996..2017
    operator :swt, 2007..2017
    operator :swr, 2017..2021
    make :eastleigh
    based_on "1938 Stock", start_socket_gravity: 800
    y 2
end

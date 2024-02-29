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

OPERATORS = {
    anglia: "Anglia Railways",
    arriva_northern: "Arriva Trains Northern",
    arriva_wales: "Arriva Trains Wales",
    avanti: "Avanti West Coast",
    br: "British Rail",
    c2c: "c2c",
    caledonian_sleeper: "Caledonian Sleeper",
    central: "Central Trains",
    chiltern: "Chiltern Railways",
    connex_sc: "Connex South Central",
    connex_se: "Connex South East",
    db: "DB Cargo",
    ec: "East Coast",
    el: "Elizabeth Line",
    emr: "East Midlands Railway",
    es: "Eurostar",
    fcc: "First Capital Connect",
    first_ge: "First Great Eastern",
    first_gw: "First Great Western",
    first_gwl: "First Great Western Link",
    first_nw: "First North Western",
    first_scotrail: "First ScotRail",
    first_tpe: "First TransPennine Express",
    ga: "Greater Anglia",
    gatwick_trains: "Gatwick Trains",
    gbrf: "GB Railfreight",
    gn: "Great Northern",
    gner: "GNER",
    govia_tl: "Thameslink",
    grand_central: "Grand Central",
    gwr: "Great Western Railway",
    gx: "Gatwick Express",
    heathrow_connect: "Heathrow Connect",
    hull_trains: "Hull Trains",
    hx: "Heathrow Express",
    ic: "British Rail InterCity",
    lner: "LNER",
    lnwr: "London Northwestern Railway",
    lo: "London Overground",
    london_midland: "London Midland",
    lts: "LTS Rail",
    lu: "London Underground",
    merseyrail: "Merseyrail",
    mml: "Midland Mainline",
    northern: "Northern",
    nse: "Network Southeast",
    nx_scotrail: "National Express ScotRail",
    nx_wales: "Wales and West/Borders",
    nxea: "National Express East Anglia",
    nxec: "National Express East Coast",
    res: "Rail Express Systems",
    rr: "Regional Railways",
    scotrail: "ScotRail",
    se: "Southeastern",
    serco_abellio_northern: "Serco/Abellio Northern Rail",
    set: "South East Trains",
    silverlink: "Silverlink",
    southern: "Southern",
    stagecoach_em: "Stagecoach East Midlands",
    stagecoach_il: "Stagecoach Island Line",
    supertram: "South Yorkshire Supertram",
    swr: "South Western Railway",
    swt: "Stagecoach South West Trains",
    tfl_rail: "TfL Rail",
    tfw: "Transport for Wales Rail",
    thames: "Thames Trains",
    tl: "Thameslink",
    tpe: "TransPennine Express",
    tyne_wear: "Tyne & Wear Metro",
    valley_lines: "Valley Lines",
    virgin_ec: "Virgin East Coast",
    virgin_wc: "Virgin West Coast",
    virgin_xc: "Virgin CrossCountry",
    wagn: "West Anglia Great Northern",
    wessex: "Wessex Trains",
    wmr: "West Midlands Railway",
    xc: "CrossCountry",
}

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
    operator :southern, 2001..2004
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
    operator :valley_lines, 1996..2001
    operator :virgin_xc, 1996..2002
    operator :virgin_wc, 1996..2003
    operator :nx_wales, 2001..2003
    operator :anglia, 1996..2004
    operator :arriva_northern, 2003..2004
    operator :gatwick_trains, 1996..2005
    operator :wessex, 2002..2006
    operator :nxea, 2004..2006
    operator :arriva_wales, 2003..2018
    operator :nx_scotrail, 1996..2008
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

    y 19
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
    operator :nx_scotrail, 1996..2008
    operator :nxea, 2002..2012
    operator :virgin_wc, 1996..2014
    operator :first_gw, 1996..2015
    operator :first_scotrail, 2008..2015
    operator :arriva_wales, 2012..2018
    operator :caledonian_sleeper, 2015..2019
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
    based_on "Mark 3A", start_x: 45, end_x: 45, start_socket: :bottom, end_socket: :top
    yo 5
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

stock "Metrocar" do
    built 1975..1981
    traction :ole1500
    operator :tyne_wear, 1975..1981
    make :birmingham
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
    yo 2
end

stock 508 do
    built 1979..1980
    traction :third_rail
    operator :br, 1978..1982
    operator :rr, 1982..1996
    operator :connex_se, 1998..2003
    operator :set, 2003..2006
    operator :se, 2006..2008
    operator :silverlink, 2003..2013
    operator :merseyrail, 1996..2024
    based_on 507, end_socket: :left, start_x: 50, start_socket: :bottom
end

stock "D78 Stock" do
    built 1978..1981
    traction :third_rail
    operator :lu, 1980..2017
    make :birmingham
    wiki "London Underground D78 Stock"
    based_on "1973 Stock", end_socket: :top, end_x: 50
    yo 1
end

stock 314 do
    built 1979
    traction :ole25kv
    operator :br, 1979..1982
    operator :rr, 1982..1996
    operator :nx_scotrail, 1996..2004
    operator :first_scotrail, 2004..2015
    operator :scotrail, 2015..2019
    make :york
    based_on 313
    yo 1
end

stock 370 do
    built 1977..1980
    traction :ole25kv
    operator :br, 1980..1982
    operator :ic, 1982..1986
    make :derby
    y 24
end

stock 140 do
    built 1979..1981
    traction :diesel
    operator :br, 1979..1982
    operator :rr, 1982..1986
    make :derby, :leyland
    y 18
end

stock 315 do
    built 1980..1981
    traction :ole25kv
    operator :br, 1980..1982
    operator :nse, 1982..1996
    operator :first_ge, 1996..2004
    operator :wagn, 1996..2004
    operator :nxea, 2004..2012
    operator :ga, 2012..2015
    operator :lo, 2015..2020
    operator :tfl_rail, 2015..2022
    operator :el, 2022..2022
    make :york
    based_on 313
end

stock "1983 Stock" do
    built 1980..1988
    traction :fourth_rail
    operator :lu, 1984..1998
    make :birmingham
    based_on "D78 Stock"
end


stock 317 do
    built 1981..1987
    traction :ole25kv
    operator :nse, 1983..1996
    operator :lts, 1997..2000
    operator :c2c, 2000..2002
    operator :wagn, 1996..2004
    operator :govia_tl, 1997..2006
    operator :nxea, 2004..2012
    operator :fcc, 2006..2014
    operator :ga, 2012..2022
    operator :lo, 2015..2020
    based_on "Mark 3A", start_x: 645, end_x: 45, start_socket: :bottom, end_socket: :top
    make :derby
    yo 2
end

stock 210 do
    built 1980
    traction :diesel
    operator :nse, 1982..1987
    based_on "Mark 3A", start_x: 450, start_socket: :bottom
    make :derby
end

stock 413 do
    built 1982
    traction :third_rail
    operator :nse, 1982..1995
    make :eastleigh
    based_on "414/2"
end

stock 455 do
    built 1982..1985
    traction :third_rail
    operator :nse, 1982..1996
    operator :connex_sc, 1996..2001
    operator :swt, 1996..2017
    operator :southern, 2001..2022
    operator :swr, (2017..)
    make :york
    based_on 317, start_x: 45, start_socket: :bottom
    yo 1
end

# exclude 488 as literally just Mk2s
# exclude 489 as not passenger stock

stock 141 do
    built 1984
    traction :diesel
    operator :rr, 1984..1996
    make :derby, :leyland
    based_on 140
    yo 1
end

stock 150 do
    built 1984..1987
    traction :diesel
    operator :rr, 1984..1996
    operator :nx_wales, 1996..2003
    operator :first_nw, 1996..2004
    operator :arriva_northern, 1996..2004
    operator :anglia, 1996..2004
    operator :nx_scotrail, 1997..2004
    operator :first_scotrail, 2004..2005
    operator :nxea, 2004..2005
    operator :wessex, 2001..2006
    operator :central, 1996..2007
    operator :silverlink, 1999..2007
    operator :lo, 2007..2010
    operator :first_gw, 2006..2015
    operator :serco_abellio_northern, 2004..2016
    operator :london_midland, 2007..2017
    operator :arriva_wales, 2003..2018
    operator :wmr, 2017..2020
    operator :gwr, (2015..)
    operator :northern, (2016..)
    operator :lnwr, (2017..)
    operator :tfw, (2018..)
    make :york
    based_on 455, end_socket: :left
    yo 1
end

stock 142 do
    built 1985..1987
    traction :diesel
    operator :rr, 1985..1996
    operator :valley_lines, 1998..2001
    operator :nx_wales, 2001..2003
    operator :first_nw, 1996..2004
    operator :arriva_northern, 1997..2004
    operator :first_gw, 2007..2011
    operator :serco_abellio_northern, 2004..2016
    operator :arriva_wales, 2003..2018
    operator :northern, 2016..2020
    operator :tfw, 2018..2020
    make :derby, :leyland
    based_on 141, start_socket: :bottom

    yo 1
end

stock 143 do
    built 1985..1986
    traction :diesel
    make :hunsley_barclay, :walter_alexander
    based_on 141
    operator :rr, 1985..1996
    operator :nx_wales, 1996..2003
    operator :wessex, 2001..2006
    operator :first_gw, 1996..2015
    operator :arriva_wales, 2003..2018
    operator :gwr, 2015..2020
    operator :tfw, 2018..2021

    yo 3
end

stock 151 do
    built 1985
    traction :diesel
    make :birmingham
    operator :rr, 1985..1989

    y 10
end

stock 318 do
    built 1985..1986
    traction :ole25kv
    make :york
    based_on 317
    operator :rr, 1985..1996
    operator :nx_scotrail, 1996..2008
    operator :first_scotrail, 2008..2015
    operator :scotrail, (2015..)
end

stock 144 do
    built 1986..1987
    traction :diesel
    make :derby, :walter_alexander
    based_on 143, end_socket: :left
    operator :rr, 1986..1996
    operator :arriva_northern, 1996..2004
    operator :serco_abellio_northern, 2004..2016
    operator :northern, 2016..2020
end

stock 155 do
    built 1987..1988
    traction :diesel
    make :leyland
    # pacer connection is somewhar tenous but it does
    # seem like there was some influence
    based_on 142, end_x: 140, end_socket: :top
    based_on 150, start_socket: :left, start_y: 48, start_x: 2, start_socket_gravity: [-200, 200]
    operator :rr, 1987..1996
    operator :arriva_northern, 1996..2004
    operator :serco_abellio_northern, 2004..2016
    operator :northern, (2016..)
end

stock 442 do
    built 1987..1989
    traction :third_rail
    make :derby
    based_on "Mark 3A", start_socket: :bottom, start_x: 1050

    operator :nse, 1988..1996
    operator :swt, 1996..2007
    operator :gx, 2008..2017
    operator :southern, 2009..2017
    operator :swr, 2019..2020
end

stock "1986 Stock" do
    built 1986..1987
    traction :fourth_rail
    make :derby, :birmingham
    wiki "London Underground 1986 Stock"
    operator :lu, 1988..1989
end

stock 156 do
    built 1987..1989
    traction :diesel
    make :birmingham
    based_on 150
    operator :rr, 1987..1996
    operator :arriva_northern, 1996..2004
    operator :nx_scotrail, 1996..2004
    operator :first_nw, 1996..2004
    operator :central, 1997..2007
    operator :nxea, 2005..2012
    operator :first_scotrail, 2004..2015
    operator :serco_abellio_northern, 2004..2016
    operator :stagecoach_em, 2007..2019
    operator :ga, 2012..2020
    operator :emr, 2019..2023
    operator :scotrail, (2015..)
    operator :northern, (2016..)
end

stock 319 do
    built 1987..1990
    traction :ole25kv, :third_rail
    make :york
    based_on "Mark 3A", start_socket: :bottom, start_x: 1050
    operator :nse, 1987..1996
    operator :connex_sc, 1996..2001
    operator :govia_tl, 1997..2006
    operator :southern, 2001..2008
    operator :fcc, 2006..2014
    operator :tl, 2014..2017
    operator :london_midland, 2015..2017
    operator :serco_abellio_northern, 2015..2016
    operator :lnwr, 2017..2023
    operator :northern, 2016..2024

    yo 1
end

stock 321 do
    built 1988..1991
    traction :ole25kv
    make :york
    based_on 319, end_x: 45, start_x: 145
    operator :nse, 1988..1996
    operator :rr, 1991..1996
    operator :arriva_northern, 1996..2004
    operator :first_ge, 1996..2004
    operator :silverlink, 1996..2007
    operator :central, 2004..2007
    operator :fcc, 2010..2014
    operator :london_midland, 2007..2015
    operator :serco_abellio_northern, 2004..2016
    operator :gn, 2014..2016
    operator :lo, 2015..2016
    operator :northern, 2016..2020
    operator :nxea, 2004..2012
    operator :ga, 2012..2023
    yo 1
end

stock 158 do
    built 1989..1992
    traction :diesel
    make :derby
    based_on 150
    operator :rr, 1990..1996
    operator :nx_wales, 1996..2003
    operator :virgin_xc, 1996..2003
    operator :nx_scotrail, 1996..2004
    operator :arriva_northern, 1996..2004
    operator :first_nw, 1996..2004
    operator :wessex, 2001..2006
    operator :first_tpe, 2004..2006
    operator :central, 1996..2007
    operator :first_scotrail, 2004..2015
    operator :first_gw, 2006..2015
    operator :serco_abellio_northern, 2004..2016
    operator :swt, 1994..2017
    operator :arriva_wales, 2003..2018
    operator :stagecoach_em, 2007..2019
    operator :gwr, (2015..)
    operator :scotrail, (2015..)
    operator :northern, (2016..)
    operator :swr, (2017..)
    operator :tfw, (2018..)
    operator :emr, (2019..)
end

stock "Mark 4" do
    built 1989..1992
    traction :hauled
    make :birmingham
    based_on 370

    operator :ic, 1982..1996
    operator :gner, 1996..2007
    operator :ec, 2009..2015
    operator :virgin_ec, 2015..2018
    operator :lner, (2018..)
    operator :tfw, (2021..)

    yo 1
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

stock 165 do
    built 1990..1992
    traction :diesel
    make :york

    operator :nse, 1991..1996
    operator :thames, 1996..2004
    operator :first_gwl, 2004..2006
    operator :first_gw, 2006..2015
    operator :gwr, (2015..)
    operator :chiltern, (1996..)

    y 5
end

stock 320 do
    built 1990
    traction :ole25kv
    make :york
    based_on 321, end_socket: :left, start_x: 145, start_socket: :bottom

    operator :rr, 1990..1996
    operator :nx_scotrail, 1996..2004
    operator :first_scotrail, 2004..2015
    operator :scotrail, (2015..) 
end

stock 322 do
    built 1990
    traction :ole25kv
    make :york
    based_on 321, end_socket: :left, start_x: 145

    operator :nse, 1990..1997
    operator :first_nw, 1998..1999
    operator :wagn, 1997..2001
    operator :nx_scotrail, 2001..2004
    operator :nxea, 2004..2005
    operator :first_scotrail, 2005..2011
    operator :serco_abellio_northern, 2011..2016
    operator :northern, 2016..2020
    operator :ga, 2020..2022

    yo 1
end

stock 153 do
    built 1991..1992
    traction :diesel
    make :hunsley_barclay
    based_on 155

    operator :rr, 1990..1996
    operator :nx_wales, 1996..2003
    operator :anglia, 1996..2004
    operator :arriva_northern, 1996..2004
    operator :central, 1996..2007
    operator :silverlink, 1996..2007
    operator :wessex, 2001..2006
    operator :nxea, 2004..2012
    operator :first_gw, 2006..2015
    operator :serco_abellio_northern, 2004..2016
    operator :london_midland, 2007..2017
    operator :arriva_wales, 2003..2018
    operator :ga, 2012..2019
    operator :stagecoach_em, 2007..2019
    operator :wmr, 2017..2020
    operator :emr, 2019..2021
    operator :northern, (2021..)
    operator :tfw, (2018..)
    operator :scotrail, (2019..)
end

stock 465 do
    built 1991..1994
    traction :third_rail
    make :york, :birmingham
    based_on 165, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :nse, 1991..1996
    operator :connex_se, 1996..2003
    operator :set, 2003..2006
    operator :se, (2006..)
    yo 1
end

stock "1992 Stock" do
    built 1991..1994
    traction :fourth_rail
    make :derby
    operator :lu, (1993..)
    based_on "1986 Stock"
    wiki "London Underground 1992 Stock"
end

stock 159 do
    built 1992
    traction :diesel
    make :rosyth
    based_on 158, start_socket: :bottom

    operator :nse, 1993..1996
    operator :swt, 1996..2017
    operator :swr, (2017..)
end

stock 166 do
    built 1992..1993
    traction :diesel
    make :york
    based_on 165, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :nse, 1993..1996
    operator :thames, 1996..2004
    operator :first_gwl, 2004..2006
    operator :first_gw, 2006..2015
    operator :gwr, (2015..)
end

stock 323 do
    built 1992..1995
    traction :ole25kv
    make :hunslet
    # https://web.archive.org/web/20151123060152/http://www.porterbrook.co.uk:80/downloads/brochures/323%20Brochure.pdf
    based_on 465, end_socket: :left, start_x: 45, start_socket: :bottom
    operator :rr, 1994..1996
    operator :central, 1996..2007
    operator :first_nw, 1996..2004
    operator :serco_abellio_northern, 2004..2016
    operator :london_midland, 2007..2017
    operator :wmr, 2017..2024 # TODO did this happen
    operator :northern, (2016..)

    yo 2
end

stock 373 do
    built 1992..1996
    traction :ole25kv, :third_rail
    make :birmingham, :alstom_fr, :bruges

    operator :es, (1994..)
    y 3
end

stock 482 do
    built 1992..1993
    traction :fourth_rail
    make :derby
    based_on "1992 Stock", end_socket: :left, start_x: 45, start_socket: :bottom
    
    operator :nse, 1992..1994
    operator :lu, (1994..)
end

stock 466 do
    built 1993..1994
    traction :third_rail
    make :birmingham
    based_on 465, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :nse, 1991..1996
    operator :connex_se, 1996..2003
    operator :set, 2003..2006
    operator :se, (2006..)
    yo 1
end

stock 365 do
    built 1994..1995
    traction :third_rail, :ole25kv
    make :york
    based_on 465, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :nse, 1996..1997
    operator :connex_se, 1996..2003
    operator :set, 2003..2004
    operator :wagn, 1997..2006
    operator :fcc, 2006..2014
    operator :scotrail, 2018..2019
    operator :gn, 2014..2021
end

stock 325 do
    built 1995..1996
    traction :ole25kv, :third_rail
    make :derby
    based_on 319

    operator :res, 1995..1995
    operator :gbrf, 2004..2010
    operator :db, (1996..)

    yo 3
end

stock "1996 Stock" do
    built 1996..2005
    traction :third_rail
    make :birmingham
    wiki "London Underground 1996 Stock"
    based_on 465, end_socket: :top, end_x: 45, start_socket_gravity: 200

    operator :lu, (1998..)
    yo 7
end

stock "1995 Stock" do
    built 1996..2000
    traction :third_rail
    make :birmingham
    based_on "1996 Stock", end_socket: :left, start_socket: :left, start_x: 0, start_y: "75%" 
    wiki "London Underground 1995 Stock"
    
    operator :lu, (1998..)
end

stock 332 do
    built 1997..2001
    traction :ole25kv
    make :caf

    operator :hx, 1998..2020

    y 25
end

stock "168/0" do
    built 1998
    traction :diesel
    make :derby
    based_on 165

    operator :chiltern, (1996..)
end

stock 170 do
    built 1998..2005
    traction :diesel
    make :derby
    based_on "168/0", end_socket: :left, start_socket: :left, start_x: 0, start_y: "75%"

    operator :mml, 1999..2004
    operator :nx_scotrail, 1999..2004
    operator :anglia, 1999..2004
    operator :hull_trains, 2000..2005
    operator :central, 1999..2007
    operator :swt, 2000..2007
    operator :southern, 2004..2010 #ish
    operator :nxea, 2004..2012
    operator :first_scotrail, 2004..2015
    operator :first_tpe, 2006..2016
    operator :london_midland, 2007..2017
    operator :ga, 2012..2019
    operator :wmr, 2017..2023
    operator :xc, (2007..)
    operator :scotrail, (2015..) 
    operator :northern, (2018..)
    operator :tfw, (2019..)
    operator :emr, (2020..)
end

stock "168 (not /0)" do
    built 2000..2004
    traction :diesel
    make :derby
    based_on 170, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :chiltern, (2000..)

    yo 1
end

stock 458 do
    built 1998..2002
    traction :third_rail
    make :birmingham
    based_on "1995 Stock", end_socket: :left, start_x: 145, start_socket: :bottom

    operator :swt, 2000..2017
    operator :swr, (2017..)
end

stock 175 do
    built 1999..2001
    traction :diesel
    make :birmingham
    based_on 458, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :first_nw, 2000..2003
    operator :first_tpe, 2004..2006
    operator :arriva_wales, 2003..2018
    operator :tfw, (2018..)
    yo 2
end

stock 334 do
    built 1999..2002
    traction :ole25kv
    make :birmingham
    based_on 458, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :nx_scotrail, 1999..2004
    operator :first_scotrail, 2004..2015
    operator :scotrail, (2015..) 
    yo 1
end

stock 357 do
    built 1999..2002
    traction :ole25kv
    make :derby
    based_on 170, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :c2c, (2000..)

    yo 2
end

stock 375 do
    built 1999..2005
    traction :third_rail, :ole25kv
    make :derby
    based_on 357, end_socket: :left, start_socket: :left, start_x: 0, start_y: "75%"


    operator :connex_se, 2000..2003
    operator :set, 2003..2006
    operator :se, (2006..)
end

stock 460 do
    built 1999..2001
    traction :third_rail
    make :birmingham
    based_on 458, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :gatwick_trains, 2000..2008
    operator :gx, 2008..2012
end

stock 180 do
    built 2000..2001
    traction :diesel
    make :birmingham
    based_on 175, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :serco_abellio_northern, 2008..2011
    operator :first_gw, 2001..2012
    operator :hull_trains, 2009..2020
    operator :northern, 2016..2018
    operator :emr, 2020..2023
    operator :grand_central, (2020..)
end

stock 220 do
    built 2000..2001
    traction :diesel
    make :bruges, :horbury
    based_on 458, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :virgin_xc, 2000..2007
    operator :xc, (2007..)

    yo 4
end

stock 333 do
    built 2000..2003
    traction :ole25kv
    make :caf
    based_on 332, end_socket: :left

    operator :arriva_northern, 2000..2004
    operator :serco_abellio_northern, 2004..2015
    operator :northern, (2015..)
end

stock 221 do
    built 2001..2002
    traction :diesel
    make :bruges, :wakefield
    based_on 220, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :virgin_xc, 2000..2007
    operator :virgin_wc, 2007..2019
    operator :xc, (2007..)
    operator :avanti, (2019..)
    operator :grand_central, (2023..)
end

stock 377 do
    built 2001..2014
    traction :third_rail, :ole25kv
    make :derby
    based_on 375, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :fcc, 2010..2014
    operator :tl, 2014..2016
    operator :southern, (2003..)
    operator :se, (2016..)
    yo 1
end

stock 390 do
    built 2001..2012
    traction :ole25kv
    make :birmingham
    based_on 370
    based_on 458, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :virgin_wc, 2002..2019
    operator :avanti, 2019..
end

stock 360 do
    built 2002..2005
    traction :ole25kv
    make :siemens

    operator :first_ge, 2003..2004
    operator :nxea, 2004..1012
    operator :hx, 2010..2010
    operator :heathrow_connect, 2005..2018
    operator :tfl_rail, 2018..2020
    operator :ga, 2012..2021
    operator :emr, (2021..)
end

stock 444 do
    built 2002..2004
    traction :third_rail
    make :siemens
    based_on 360, start_socket: :left, end_socket: :left

    operator :swt, 2004..2017
    operator :swr, (2017..)
end

stock 450 do
    built 2002..2006
    traction :third_rail
    make :siemens
    based_on 444, start_socket: :left, end_socket: :left, start_y: "75%", start_x: 0

    operator :swt, 2003..2017
    operator :swr, (2017..)
end

stock 171 do
    built 2003..2004
    traction :diesel
    make :derby
    based_on 170

    operator :southern, (2003..)
end

stock 222 do
    built 2003..2005
    traction :diesel
    make :bruges
    based_on 220

    operator :mml, 2004..2007
    operator :hull_trains, 2005..2008
    operator :stagecoach_em, 2007..2019
    operator :emr, (2019..)
end

stock 350 do
    built 2004..2014
    traction :ole25kv, :third_rail
    make :siemens
    based_on 450, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :central, 2005..2007
    operator :silverlink, 2005..2007
    operator :souther, 2009..2009
    operator :first_tpe, 2013..2016
    operator :london_midland, 2007..2017
    operator :tpe, 2016..2020
    operator :lnwr, (2017..)
    operator :wmr, (2017..)
end

stock 376 do
    built 2004..2005
    traction :third_rail
    make :derby
    based_on 375, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :set, 2004..2006
    operator :se, (2006..)
end

stock 185 do
    built 2005..2006
    traction :diesel
    make :siemens
    based_on 360, end_x: 145, end_socket: :top

    operator :first_tpe, 2006..2016
    operator :tpe, (2016..)
end

stock 395 do
    built 2007..2009
    traction :third_rail, :ole25kv
    make :hitachi
    
    operator :se, (2009..)

    y 18
end

stock "2009 Stock" do
    built 2007..2011
    traction :fourth_rail
    make :derby
    
    operator :lu, (2009..)

    y 19
end

stock 139 do
    built 2008..2009
    traction :diesel
    make :parry

    operator :london_midland, (2009..2017)
    operator :wmr, (2017..)

    y 2
end

stock 378 do
    built 2008..2015
    traction :third_rail, :ole25kv
    make :derby

    based_on 376
    operator :lo, (2009..)
end


stock "S8 Stock" do
    built 2008..2012
    traction :third_rail
    make :derby
    based_on "2009 Stock", end_socket: :left, start_x: 45, start_socket: :bottom

    operator :lu, (2009..)
end

stock "S7 Stock" do
    built 2011..2014
    traction :fourth_rail
    make :derby
    based_on "S8 Stock", end_socket: :left, start_x: 245, start_socket: :bottom

    operator :lu, (2012..)
end

stock 380 do
    built 2009..2011
    traction :ole25kv
    make :siemens
    based_on "360"

    operator :first_scotrail, 2010..2015
    operator :scotrail, (2015..)
end

stock 172 do
    built 2010..2011
    traction :diesel
    make :derby
    based_on 170
    based_on 220, start_socket_gravity: 420 # bogies

    operator :london_midland, 2011..2017
    operator :lo, 2010..2018
    operator :chiltern, 2011..2021
    operator :wmr, (2017..)

    y 6
end

stock 374 do
    built 2011..2018
    traction :ole25kv
    make :siemens

    operator :es, (2015..)

    y 7
end

stock 379 do
    built 2010..2011
    traction :ole25kv
    make :derby
    based_on 377

    operator :nxea, 2011..2012
    operator :ga, 2012..2022
    yo 1
end

stock 387 do
    built 2014..2017
    traction :ole25kv, :third_rail
    make :derby
    based_on 379

    operator :tl, 2014..2016
    operator :c2c, 2016..2022
    operator :gwr, (2016..)
    operator :gx, (2016..)
    operator :gn, (2016..)
    operator :hx, (2020..)
end

stock 700 do
    built 2014..2018
    traction :ole25kv, :third_rail
    make :siemens

    based_on 380

    operator :tl, (2016..)
    operator :gn, (2017..)
end

stock 800 do
    built 2014..2018
    traction :ole25kv, :diesel
    make :hitachi

    based_on 395

    operator :gwr, (2017..)
    operator :lner, (2019..)
end

stock 801 do
    built 2017..2020
    traction :ole25kv
    make :hitachi

    based_on 800, end_socket: :left, start_x: 145, start_socket: :bottom

    operator :lner, (2019..)
end

stock 399 do
    built 2014..2015
    traction :ole25kv, :ole750
    make :valencia

    operator :supertram, (2017..)

    y 6
end

stock 345 do
    built 2015..2019
    traction :ole25kv
    make :derby
    based_on 379
    based_on 220, start_socket_gravity: 200

    operator :tfl_rail, 2017..2022
    operator :el, (2022..)
    yo -6
end

stock 385 do
    built 2015..2020
    traction :ole25kv
    make :hitachi

    based_on 395, end_socket: :top, end_x: 45, end_socket_gravity: 50
    operator :scotrail, (2018..)
    yo 2
end

stock 707 do
    built 2015..2018
    traction :third_rail
    make :siemens
    based_on 700, end_socket: :left, start_x: 45, start_socket: :bottom

    operator :swt, 2017..2017
    operator :swr, (2017..)
    operator :se, (2021..)
end

stock "Mark 5" do
    built 2016..2018
    traction :hauled
    make :caf
    operator :caledonian_sleeper, (2019..)
    wiki "British Rail Mark 5 (CAF)"
    
    y 2
end

stock 195 do
    built 2017..2020
    traction :diesel
    make :caf
    based_on "Mark 5"

    operator :northern, (2019..)
end

stock 769 do
    built 2017..2021
    traction :diesel, :ole25kv, :third_rail
    make :brush
    based_on 319

    operator :tfw, 2019..2023
    operator :northern, (2021..)
end

# reserved

stock 230 do
    built 2015..2022
    traction :diesel, :battery
    operator :lnwr, 2019..2022
    operator :tfw, (2023..)
    # operator :gwr, soon
    make :vivarail
    based_on "D78 Stock"
    yo 1
end

stock 484 do
    built 2020..2021
    traction :third_rail
    operator :swr, (2021..)
    make :vivarail
    based_on "D78 Stock"
end

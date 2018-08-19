module CalcTaxSandbox
  class Item
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today)
      rate = on < Date.new(2019, 10, 1) ? 1.08 : 1.1
      (price * rate).floor
    end
  end
end
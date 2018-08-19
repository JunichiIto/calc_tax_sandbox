module CalcTaxSandbox
  class Item
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today, **params)
      rate = on < Date.new(2019, 10, 1) ? 1.08 : adjustable_tax_rate(params)
      (price * rate).floor
    end

    def adjustable_tax_rate(**)
      1.1
    end
  end
end

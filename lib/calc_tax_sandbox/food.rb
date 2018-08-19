module CalcTaxSandbox
  class Food < Item
    def initialize(name, price, alcohol: false)
      super(name, price)
      @alcohol = alcohol
    end

    def alcohol?
      @alcohol
    end

    def keigen?(**options)
      !alcohol? && !options[:eating_out]
    end
  end
end
module CalcTaxSandbox
  class Food < Item
    def initialize(name, price, alcohol: false)
      super(name, price)
      @alcohol = alcohol
    end

    def alcohol?
      @alcohol
    end

    def adjustable_tax_rate(**params)
      alcohol? || params[:eating_out] ? super : 1.08
    end
  end
end
module CalcTaxSandbox
  class NewspaperSubscription < Item
    attr_reader :per_week

    def initialize(name, price, per_week: 7)
      super(name, price)
      @per_week = per_week
    end

    def adjustable_tax_rate(**)
      per_week < 2 ? super : 1.08
    end
  end
end

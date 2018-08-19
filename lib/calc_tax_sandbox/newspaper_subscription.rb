module CalcTaxSandbox
  class NewspaperSubscription < Item
    attr_reader :per_week

    def initialize(name, price, per_week: 7)
      super(name, price)
      @per_week = per_week
    end

    def keigen?(**)
      per_week >= 2
    end
  end
end

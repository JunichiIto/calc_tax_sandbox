module CalcTaxSandbox
  class PostTaxPrice
    attr_reader :without_tax, :tax

    def initialize(without_tax, tax, keigen: false)
      @without_tax = without_tax
      @tax = tax
      @keigen = keigen
    end

    def keigen?
      @keigen
    end

    def with_tax
      without_tax + tax
    end
  end
end

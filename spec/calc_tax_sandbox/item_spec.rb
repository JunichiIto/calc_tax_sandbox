require 'date'

RSpec.describe CalcTaxSandbox::Item do
  describe '#price_with_tax' do
    subject { item.price_with_tax(on: date) }
    context '食品でも新聞でもない場合' do
      let(:item) { CalcTaxSandbox::Item.new('プロを目指す人のためのRuby入門', 2980) }
      context '2019-09-30の場合' do
        let(:date) { Date.new(2019, 9, 30)  }
        it { is_expected.to eq 3218 }
      end
      context '2019-10-01の場合' do
        let(:date) { Date.new(2019, 10, 1)  }
        it { is_expected.to eq 3278 }
      end
    end
    context '食品だった場合' do
      context '酒類だった場合' do
        let(:item) { CalcTaxSandbox::Food.new('ビール', 300, alcohol: true) }
        context '2019-09-30の場合' do
          let(:date) { Date.new(2019, 9, 30)  }
          it { is_expected.to eq 324 }
        end
        context '2019-10-01の場合' do
          let(:date) { Date.new(2019, 10, 1)  }
          it { is_expected.to eq 330 }
        end
      end
      context '酒類でなかった場合' do
        let(:item) { CalcTaxSandbox::Food.new('ハンバーガー', 300) }
        context '2019-09-30の場合' do
          let(:date) { Date.new(2019, 9, 30)  }
          it { is_expected.to eq 324 }
        end
        context '2019-10-01の場合' do
          let(:date) { Date.new(2019, 10, 1)  }
          it { is_expected.to eq 324 }
          context '外食だった場合' do
            subject { item.price_with_tax(on: date, eating_out: true) }
            it { is_expected.to eq 330 }
          end
        end
      end
    end
    context '新聞の定期購読だった場合' do
      context '週1回発行の場合' do
        let(:item) { CalcTaxSandbox::NewspaperSubscription.new('Ruby新聞', 5000, per_week: 1) }
        context '2019-09-30の場合' do
          let(:date) { Date.new(2019, 9, 30)  }
          it { is_expected.to eq 5400 }
        end
        context '2019-10-01の場合' do
          let(:date) { Date.new(2019, 10, 1)  }
          it { is_expected.to eq 5500 }
        end
      end
      context '週2回発行の場合' do
        let(:item) { CalcTaxSandbox::NewspaperSubscription.new('Ruby新聞', 5000, per_week: 2) }
        context '2019-09-30の場合' do
          let(:date) { Date.new(2019, 9, 30)  }
          it { is_expected.to eq 5400 }
        end
        context '2019-10-01の場合' do
          let(:date) { Date.new(2019, 10, 1)  }
          it { is_expected.to eq 5400 }
        end
      end
    end
  end
end
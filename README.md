# enumb

Authors: Jason Young

Enumb helps developers create an enum class in Ruby that closely resembles commonly found enum behavior in most popular languages.

## Installation

Add this line to your application's Gemfile:

    gem 'enumb'

Install as Ruby Gem:

    gem install enumb

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enumb

## Usage

Simply extend the Enumb module and define a class with as many enumerators as desired.

Example:
```ruby
class TestEnumByte
   extend Enumb
   enumerator :Nones => 0x0000
   enumerator :Somes => 0x0001
   enumerator :Anys => 0x0002
   enumerator :Each => 0x0004
end
```

Further examples can be seen in spec test:

```ruby
require 'Enumb'
describe 'Enumb' do
  context 'Given a class extends Enumb' do
    it 'if not passed a hash expect exception' do
      class TestEnumNoHash
        extend Enumb

        def init_enumerators
          enumerator 'None'
        end
      end
      expect { puts TestEnumNoHash.whatever }.to raise_error(Exception)
    end
    it 'if class has enumerator undefined expect exception' do
      class TestEnumUndefined
        extend Enumb
        enumerator 'None' => '123'
      end
      expect { puts TestEnumUndefined.whatever }.to raise_error(Exception)
    end
    it 'if class has multiple nodes defined for enumerator hash expect exception' do
      expect {
        class TestEnumMultiple
          extend Enumb
          enumerator :None => '123', :Stuff => 456
        end
        TestEnumMultiple.None
      }.to raise_error(Exception)
    end
    it 'if class does not have referenced enumerator defined expect exception' do
      class TestEnumMissing
        extend Enumb
        #nothing here
      end
      expect { puts TestEnumMissing.whatever }.to raise_error(Exception)
    end
    it 'if enum class enumerator keys are strings, values should evaluate correctly' do
      class TestEnumStringKeys
        extend Enumb
        enumerator 'None' => '123'
        enumerator 'Some' => '456'
      end
      expect(TestEnumStringKeys.None).to eq('123')
    end
    it 'if enum class enumerator keys are symbols, values should evaluate correctly' do
      class TestEnumSyms
        extend Enumb
        enumerator :Nones => '123'
        enumerator :Somes => '456'
      end
      expect(TestEnumSyms.Nones).to eq('123')
    end
    it 'if enum class has byte valued enumerators, bitwise comparisons should evaluate correctly' do
      class TestEnumByte
        extend Enumb
        enumerator :Nones => 0x0000
        enumerator :Somes => 0x0001
        enumerator :Anys => 0x0002
        enumerator :Each => 0x0004
      end

      testItem = TestEnumByte.Nones
      testItem = testItem | TestEnumByte.Anys
      expect(((testItem & TestEnumByte.Each) == TestEnumByte.Each)).to eq(false)
      expect(((testItem & TestEnumByte.Anys) == TestEnumByte.Anys)).to eq(true)
      expect(((testItem & TestEnumByte.Anys) != 0)).to eq(true)
      expect(((testItem & TestEnumByte.Somes) != 0)).to eq(false)
    end
    it 'if enum values are ints values should evaluate correctly' do
      class TestEnumInts
        extend Enumb
        enumerator :Nones => 1
        enumerator :Somes => 2
        enumerator :Anys => 3
        enumerator :Each => 4
      end
      expect(TestEnumInts.Nones).to eq(1)
      expect(TestEnumInts.Somes).to eq(2)
      expect(TestEnumInts.Anys).to eq(3)
      expect(TestEnumInts.Each).to eq(4)
    end
    it 'if enum values are bools values should evaluate correctly' do
      class Tristate
        extend Enumb
        enumerator :True => true
        enumerator :False => false
        enumerator :Undef => 'Undefined'
      end
      expect(Tristate.True).to eq(true)
      expect(Tristate.False).to eq(false)
      expect(Tristate.Undef).to eq('Undefined')
    end
    it 'if to_descriptor called, should evaluate correctly' do
      class TestEnumDescriptor
        extend Enumb
        enumerator :Nones => '123'
        enumerator :Somes => '456'
      end
      expect(TestEnumDescriptor.to_descriptor('123')).to eq('Nones')
    end
    it 'if to_value called, should evaluate correctly' do
      class TestEnumToValue
        extend Enumb
        enumerator :Nones => '123'
        enumerator :Somes => '456'
      end
      expect(TestEnumToValue.to_value(:Nones)).to eq('123')
    end
    it 'if iterate over enum correct values yielded' do
      class TestEnumToIterate
        extend Enumb
        enumerator :Nones => 0x0000
        enumerator :Somes => 0x0001
        enumerator :Anys => 0x0002
        enumerator :Each => 0x0004
      end

      TestEnumToIterate.each do |x|
        expect((((TestEnumToIterate.Nones |
            TestEnumToIterate.Somes |
            TestEnumToIterate.Anys |
            TestEnumToIterate.Each) & x) == x)).to eq(true)
      end
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

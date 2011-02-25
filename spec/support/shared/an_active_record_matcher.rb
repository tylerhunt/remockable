shared_examples_for 'an Active Record matcher' do
  let(:matcher_name) { self.class.parent.parent.description }

  before(:all) do
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
    )
  end

  context 'description' do
    let(:matcher) { send(matcher_name, *columns) }

    it 'has a custom description' do
      name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
      columns = matcher.instance_variable_get(:@columns).to_sentence
      with = " with #{matcher.expected}" if matcher.expected.any?

      matcher.description.should == "#{name} on #{columns}#{with}"
    end
  end

  context 'failure messages' do
    let(:matcher) { send(matcher_name, *columns) }

    before(:each) { matcher.matches?(subject) }

    it 'has a custom failure message' do
      matcher.failure_message.should ==
        "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'sets a custom negative failure message' do
      matcher.negative_failure_message.should ==
        "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  context "with an unknown option" do
    it 'raises an error' do
      expect {
        send(matcher_name, :xxx => true)
      }.to raise_error(ArgumentError, /unknown.*:xxx/i)
    end
  end
end

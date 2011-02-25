shared_examples_for 'an Active Record matcher' do
  let(:matcher_name) { self.class.parent.parent.description }

  before(:all) do
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
    )
  end

  context 'failure messages' do
    let(:matcher) { send(matcher_name, *options) }

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

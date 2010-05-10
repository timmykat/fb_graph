require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Events, '#events' do
  context 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'matake/events', 'users/events/matake_public')
      fake_json(:get, 'matake/events?access_token=access_token', 'users/events/matake_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('matake').events
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return events as FbGraph::Event' do
        events = FbGraph::User.new('matake', :access_token => 'access_token').events
        events.first.should == FbGraph::Event.new(
          '116600818359630',
          :name => 'The Loyal We @ Rainy Day Bookstore and Cafe',
          :start_time => '2010-04-29T01:30:00+0000',
          :end_time => '2010-04-29T04:30:00+0000',
          :location => 'Nishi Azabu'
        )
        events.each do |event|
          event.should be_instance_of(FbGraph::Event)
        end
      end
    end
  end
end
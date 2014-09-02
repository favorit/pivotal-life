require 'spec_helper'
require 'timecop'
require 'webmock'
include WebMock::API

describe CalendarFetcher do
  let(:calendar_url) { 'http://cal.g.com/api' }
  let(:fetcher) { CalendarFetcher.new calendar_url }

  before do
    expect(DateTime).to receive(:now).and_return(DateTime.new(2014, 02, 02, 15, 30, 0, '-5'))
    url = calendar_url + '?orderby=starttime&singleevents=true&start-max=2014-02-10T00:00:00%2B00:00&start-min=2014-02-02T15:30:00-05:00'
    stub_request(:get, url).to_return(body: File.read('spec/fixtures/calendar.xml'))
  end

  it 'fetches events in sorted order by starting date ascending' do
    expect(fetcher.data.first[:title]).to eq "Tech videos"
    expect(fetcher.data.last[:title]).to eq "Whiskey Club"
  end

  it 'fetches events between now and the next Sunday (even if today is a Sunday)' do
    expect(fetcher.data).to match_array [
      {:title => "Whiskey Club",
       :body => "",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391824800,
       :when_end_raw => 1391828400,
       :when_start => Time.parse('2014-02-08 02:00:00 UTC'),
       :when_end => Time.parse('2014-02-08 03:00:00 UTC')},
      {:title => "Pivotal Board Games Night!",
       :body => "",
       :calendar => "",
       :where => "Event space, 4th floor, 875 Howard St, SF, CA 94103",
       :when_start_raw => 1391738400,
       :when_end_raw => 1391751000,
       :when_start => Time.parse('2014-02-07 02:00:00 UTC'),
       :when_end => Time.parse('2014-02-07 05:30:00 UTC')},
      {:title => "Meetup: Hadoop and Storage Technologies with Sameer Tiwari",
       :body => "",
       :calendar => "",
       :where => "SF 4th Fl - Event Space (~100 people)",
       :when_start_raw => 1391738400,
       :when_end_raw => 1391745600,
       :when_start => Time.parse('2014-02-07 02:00:00 UTC'),
       :when_end => Time.parse('2014-02-07 04:00:00 UTC')},
      {:title => "Review Writing Lunch",
       :body => "",
       :calendar => "",
       :where => "SF Conf - Titanium (~12 people) 415-777-4868 x1381",
       :when_start_raw => 1391718600,
       :when_end_raw => 1391722200,
       :when_start => Time.parse('2014-02-06 20:30:00 UTC'),
       :when_end => Time.parse('2014-02-06 21:30:00 UTC')},
      {:title => "Lunchtime card games",
       :body => "",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391718600,
       :when_end_raw => 1391722200,
       :when_start => Time.parse('2014-02-06 20:30:00 UTC'),
       :when_end => Time.parse('2014-02-06 21:30:00 UTC')},
      {:title => "Weekday Night Drinking Club",
       :body =>
         "Location is red couches by elevators and\n      everyone is welcome\n    ",
       :calendar => "",
       :where => "Meet by the red couches in front of the elevators",
       :when_start_raw => 1391652900,
       :when_end_raw => 1391663700,
       :when_start => Time.parse('2014-02-06 02:15:00 UTC'),
       :when_end => Time.parse('2014-02-06 05:15:00 UTC')},
      {:title => "500 Startups",
       :body => "",
       :calendar => "",
       :where => "SF 5th Fl - Event Space (~100 people)",
       :when_start_raw => 1391652000,
       :when_end_raw => 1391662800,
       :when_start => Time.parse('2014-02-06 02:00:00 UTC'),
       :when_end => Time.parse('2014-02-06 05:00:00 UTC')},
      {:title => "Lunchtime drawtime",
       :body => "",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391632200,
       :when_end_raw => 1391635800,
       :when_start => Time.parse('2014-02-05 20:30:00 UTC'),
       :when_end => Time.parse('2014-02-05 21:30:00 UTC')},
      {:title => "eXtreme Tuesday Meetup",
       :body =>
         "An SF meeting each week to talk about eXtreme Programming, Test Driven Development and all\n      sorts of geeky stuff.\n    ",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391567400,
       :when_end_raw => 1391578200,
       :when_start => Time.parse('2014-02-05 02:30:00 UTC'),
       :when_end => Time.parse('2014-02-05 05:30:00 UTC')},
      {:title => "[Tech Talk] Diego Ongaro - The Raft Consensus Algorithm",
       :body => "",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391545800,
       :when_end_raw => 1391549400,
       :when_start => Time.parse('2014-02-04 20:30:00 UTC'),
       :when_end => Time.parse('2014-02-04 21:30:00 UTC')},
      {:title => "Yoga",
       :body => "",
       :calendar => "",
       :where => "",
       :when_start_raw => 1391480100,
       :when_end_raw => 1391483700,
       :when_start => Time.parse('2014-02-04 02:15:00 UTC'),
       :when_end => Time.parse('2014-02-04 03:15:00 UTC')},
      {:title =>
         "Cluster Packaging for Continuous Integration & Disaster Recovery - Tony Hansmann",
       :body => "",
       :calendar => "",
       :where => "SF 4th Fl - Event Space (~100 people)",
       :when_start_raw => 1391479200,
       :when_end_raw => 1391488200,
       :when_start => Time.parse('2014-02-04 02:00:00 UTC'),
       :when_end => Time.parse('2014-02-04 04:30:00 UTC')},
      {:title => "Tech videos",
       :body => "",
       :calendar => "",
       :where => "SF Conf - Titanium (~12 people) 415-777-4868 x1381",
       :when_start_raw => 1391459400,
       :when_end_raw => 1391463000,
       :when_start => Time.parse('2014-02-03 20:30:00 UTC'),
       :when_end => Time.parse('2014-02-03 21:30:00 UTC')}
    ]
  end
end

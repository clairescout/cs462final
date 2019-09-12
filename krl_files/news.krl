ruleset news {
  meta {
    use module news_keys
    use module news_api alias api
      with news_key = keys:news_keys{"news_key"}
    shares __testing, news
  }

  global {

     __testing = { "queries": [ { "name": "__testing" },
                                { "name": "news" },],
                  "events": [ { "domain": "news", "type": "initialize"},
                              {"domain": "news", "type": "news_scheduled"} ] }
    news = function() {
      ent:news
    }
  }

  rule initialize_news {
    select when news initialize
    always {
      schedule news event "news_scheduled" repeat "1 7 * * *" // 1 minute after 7 every day
    }
  }

  rule news_event {
    select when news news_scheduled
    pre {
      result = api:get_news()
    }
    always {
      ent:news := ent:news.defaultsTo({});
      ent:news := result;
      raise news event "update"
    }
  }
}

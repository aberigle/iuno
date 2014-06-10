do ->

  show = (symbol, color, text) ->
    chrome.browserAction.setBadgeText text: symbol
    chrome.browserAction.setBadgeBackgroundColor color: color
    chrome.browserAction.setTitle title: text

  ###
  returns the number of notifications on twitter or:
    - (-1) if it couldn't connect to twitter
    - (-2) if it couldn't locate the notification count
  ###
  getNotificationCount = (callback) ->
    tmp = document.createElement 'div'
    API.twitter.get (response) =>
      count  = 0
      html   = response.responseText
      status = response.status
      
      if status isnt 200 then callback -1
      
      tmp.innerHTML = html
      span = tmp.querySelector 'a[href="/i/notifications"] .count-inner'

      if span then callback span.innerText
      else callback -2       

  updateBadge = ->
    getNotificationCount (count) =>
      if count < 0
        message = switch count
          when -1 then "Unable to reach twitter.com"
          when -2 then "Unable to the notification count"
        show "?", [0, 0, 0, 255], message
      else
        show count, [86, 0, 58, 255], "Twitter notifications"

  chrome.alarms.create periodInMinutes: 1
  chrome.alarms.onAlarm.addListener updateBadge
  chrome.runtime.onMessage.addListener updateBadge

  chrome.browserAction.onClicked.addListener ->
    chrome.tabs.create url: API.clickUrl

  updateBadge();


#https://twitter.com/i/notifications
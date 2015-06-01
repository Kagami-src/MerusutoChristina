#= require jquery/dist/jquery
#= require decorators/jquery.deparam

Configuration =
  "骑士契约书（钻石）":
    id: 1
    chance: [0.78, 3.10, 12.02, 84.10]
    statistic: [2..5]
    description: "双三星保底"
  "勇者契约书（金币2W）":
    id: 2
    chance: [0, 0.95, 2.95, 96.1]
    statistic: [2..4]
  "游侠契约书（金币2K）":
    id: 3
    chance: [0, 0, 0.18, 1.85, 97.97]
    statistic: [1..3]

LocalStorageSupport = try
  localStorage.setItem('test', 1)
  localStorage.removeItem('test')
  true
catch e
  false

Template = null
Config = null
Chance = []

shuffle = (array) ->
  currentIndex = array.length

  # While there remain elements to shuffle...
  while (currentIndex != 0)
    # Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex)
    currentIndex -= 1

    # And swap it with the current element.
    temporaryValue = array[currentIndex]
    array[currentIndex] = array[randomIndex]
    array[randomIndex] = temporaryValue

  array

randomPick = (data) ->
  groupedData = {}
  for d in data
    continue unless d.gacha && Config.id in d.gacha
    (groupedData[d.rare] ||= []).push(d)

  resultData = []
  rare2Count = 0
  for i in [0..9]
    r = Math.random()
    if r < Chance[0]
      rare = 5
    else if r < Chance[1]
      rare = 4
    else if r < Chance[2]
      rare = 3
    else if r > Chance[3]
      rare = 1
    else if Config.id == 1 && i > 7 && rare2Count + 1 >= i
      rare = 3
    else
      rare2Count += 1
      rare = 2

    d = groupedData[rare]
    resultData.push d[Math.floor(Math.random() * d.length)]

  shuffle(resultData)

$(window).load ->
  if document.body.style.webkitFilter?
    $body = $("body")
    $body.data("html", $body.html())
    $.getJSON "../data/units.json", (data) ->
      $body.data("data", data)
      initPage(data)
  else
    alert("目前只支持webkit内核浏览器，请使用Chrome、Safari等浏览器再试")

initPage = (data) ->
  $background = $("#background")
  $background.find(".loading-bar").fadeOut(200)

  $foreground = $("#foreground")
  $buttonGroup = $foreground.find(".button-group-gacha")
  $buttonGroup.fadeIn(200)
  $foreground.find(".button-gacha").click ->
    Template = $(this).attr("alt")
    Config = Configuration[Template]

    sum = 0
    for i in [0..4]
      sum += Config.chance[i]
      Chance.push sum / 100

    $buttonGroup.fadeOut(200)
    $background.find(".loading-bar").fadeIn(200)

    initStatistic()
    initGacha(data)

initStatistic = ->
  $foreground = $("#foreground")
  $foreground.find(".button-statistics").fadeIn()
  $foreground.on "click", ".button-statistics", (event) ->
    event.stopPropagation()
    generateText = (result, indexes) ->
      count = 0
      for i in [1..5]
        count += parseInt(result[i]) || 0
      ret = []
      for i in indexes
        t = "#{[null,"一","二","三","四","五"][i]}星："
        t += "#{parseInt(result[i]) || 0}个"
        t += "，占#{((parseInt(result[i]) || 0) / count * 100).toFixed(2)}%" unless count == 0
        ret.push t
      "抽卡#{count / 10}次，共获得：\n#{ret.join("；\n")}。"

    ret = []
    for c, i in Config.chance
      ret.push "#{["五","四","三","二","一"][i]}星：#{c}%" if c != 0
    ret.push Config.description if Config.description?

    text = "#{Template}，模拟抽卡概率设置为：\n#{ret.join("；")}。\n\n"

    currentResult = $("body").data("gachaResult") || {}
    text += "本次#{generateText(currentResult, Config.statistic)}\n\n"

    if LocalStorageSupport
      totalResult = $.deparam(localStorage["gachaResult#{Config.id}"] || "") || {}
      text += "总计#{generateText(totalResult, Config.statistic)}"

    alert text

  ga?('send', hitType: 'event', eventCategory: 'gacha', eventAction: 'reload');

initGacha = (data) ->
  pickedData = randomPick(data)
  Result = (d.id for d in pickedData)

  maxRare = null
  for d in pickedData
    maxRare = d.rare if maxRare < d.rare

  r = Math.random()
  if maxRare == 5
    if r < 0.05
      background = "morning"
    else if r < 0.1
      background = "evening"
    else
      background = "night"
  else if maxRare == 4
    if r < 0.1
      background = "morning"
    else
      background = "evening"
  else
    background = "morning"

  preloadCount = 0
  preloadCallback = ->
    preloadCount -= 1
    if preloadCount == 0
      prepareGacha(background, pickedData)
      startGacha(pickedData)

  $preload = $("#preload")
  preloadImage = (url) ->
    preloadCount += 1
    $("<img src='#{url}' />").appendTo($preload)
      .load(preloadCallback)
      .error(preloadCallback)

  preloadImage("../images/gacha/background_#{background}.png")
  for i in [0..9]
    item = pickedData[i]
    preloadImage("../data/units/original/#{item.id}.png")
    preloadImage("../data/units/thumbnail/#{item.id}.png")


prepareGacha = (background, pickedData) ->
  $("#gacha-background .background-image").addClass(background)

  $foreground = $("#foreground")
  $finish = $foreground.find(".finish")
  for i in [0..9]
    item = pickedData[i]

    $foreground.find(".gacha").eq(i).find(".unit, .unit-shadow")
      .css("background-image", "url('../data/units/original/#{item.id}.png')")
    $finish.find(".unit").eq(i)
      .css("background-image", "url('../data/units/thumbnail/#{item.id}.png')")

    $stars = $("<div class='stars'></div>").appendTo($foreground.find(".gacha").eq(i))
    for i in [0...item.rare]
      $stars.append("<img class='star' src='../images/gacha/star.png' alt=''>")

startGacha = (pickedData) ->
  $page = $("#page")
  $background = $("#background")
  $foreground = $("#foreground")
  $background.find(".loading-bar").fadeOut(200)

  $lastActive = null
  busy = false
  callbacks = []
  callbacks.push ->
    $page.addClass("ready")
    $foreground.find(".welcome").fadeOut(200)
    $lastActive = $foreground.find(".ready")
    setTimeout ->
      $lastActive.addClass("active-300")
    , 300
    setTimeout ->
      $lastActive.addClass("active-500")
      busy = false
    , 500

  makeCallback = (index) ->
    return ->
      $page.addClass("gacha")
      $lastActive.fadeOut(200)
      $lastActive = $foreground.find(".gacha").eq(index)
      setTimeout ->
        $lastActive.addClass("active")
      , if index == 0 then 1000 else 0
      setTimeout ->
        $lastActive.addClass("active-1000")
        for i in [0..4]
          makeCallback = (index) ->
            return ->
              $lastActive.find(".stars .star").eq(index).addClass("active")
          setTimeout makeCallback(i), 100 * i + 100
        busy = false
      , if index == 0 then 2000 else 1000

  for i in [0..9]
    callbacks.push makeCallback(i)

  callbacks.push ->
    saveResult(pickedData)
    $page.addClass("finish")
    $lastActive.fadeOut(200)
    $lastActive = $foreground.find(".finish")
    $lastActive.addClass("active")
    for i in [0..9]
      makeCallback = (index) ->
        return ->
          $lastActive.find(".unit").eq(index).fadeIn(200)
      setTimeout makeCallback(i), 100 * i
    setTimeout ->
      busy = false
      $foreground.on "click", ->
        $body = $("body")
        $body.prepend($body.data("html"))
        $page.fadeOut 200, ->
          $page.remove()
          initGacha($body.data("data"))
          initStatistic()
    , 1000

  $foreground.on "click", ->
    unless busy
      busy = true
      callbacks.shift()?()

  $foreground.on "click", ".skip", (event) ->
    event.stopPropagation()
    callbacks.pop()?()
    callbacks = []

saveResult = (pickedData) ->
  result = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
  for d in pickedData
    result[d.rare] += 1

  $body = $("body")

  appendResult = (appendedResult, result) ->
    for i in [1..5]
      appendedResult[i] = (result[i] || 0) +
        (parseInt(appendedResult[i]) || 0)

  currentResult = $body.data("gachaResult") || {}
  appendResult(currentResult, result)
  $body.data("gachaResult", currentResult)

  if LocalStorageSupport
    totalResult = $.deparam(localStorage["gachaResult#{Config.id}"] || "") || {}
    appendResult(totalResult, result)
    localStorage["gachaResult#{Config.id}"] = $.param(totalResult)


#= reuqire ../dropdown
#= reuqire ./item
{VirtualList, WithScope, Dropdown, Units} = App.Components

sortByKey = (p) ->
  if p[0] == "-" then p = p[1..-1]; o = -1 else o = 1
  (a, b) -> if (a[p] < b[p]) then o else if (a[p] > b[p]) then -o else 0

App.Components.Units.Index = React.createClass
  displayName: "UnitIndex"
  mixins: [App.Mixins.RenderPartials, App.Mixins.SharedState("unit")]

  getInitialState: ->
    filters:
      conditions: {}
      sortMode: "rare"
      levelMode: "zero"

  handleChange: (change) ->
    filters = React.addons.update(@state.filters, change)
    @setSharedState(filters: filters)

  sortItems: (items, sortBy) ->
    items.sort sortByKey(sortBy)

  checkItem: (item, conditions) ->
    for key, rule of conditions
      value = item[key]
      if typeof rule == "number" || typeof rule == "string"
        return false unless value == rule
      else if typeof rule == "object"
        if rule instanceof Array
          return false unless rule.indexOf value >= 0
        else
          return false if rule.$max && rule.$max < value
          return false if rule.$min && rule.$min > value
    return true

  filterItems: (items, conditions) ->
    result = []
    for item in items
      result.push item if @checkItem(item, conditions)
    result

  componentWillReceiveSharedState: (nextState) ->
    @inPartial "Main", ->
      @calculateDPS(@items)
      items = @items?.slice()
      items = @sortItems(items, nextState.filters.sortMode)
      items = @filterItems(items, nextState.filters.conditions)
      nextState.items = items

  calculateDPS: (items) ->
    for item in items
      item["dps"] = Math.round(item["atk"] / item["aspd"])
      item["mdps"] = Math.round(item["atk"] / item["aspd"] * item["anum"])

  componentDidMount: ->
    @inPartial "Main", ->
      fetch("../data/units.json")
        .then (response) ->
          return response.json()
        .then (data) =>
          @items = data
          @calculateDPS(@items)
          items = @items?.slice()
          items = @sortItems(items, @state.filters.sortMode)
          items = @filterItems(items, @state.filters.conditions)
          @setState(items: items)

  render: -> @separatePartials("render")

  renderMain: ->
    <ReactList itemRenderer={@renderItem} itemsRenderer={@renderItems}
      length={@state.items?.length} filters={@state.filters}/>

  renderItems: (items, ref) ->
    <ul className="table-view" ref={ref}>
      {items}
    </ul>

  renderItem: (index, key) ->
    item = @state.items[index]
    <Units.Item item={item} key={item.id}/>

  renderHeaderFilters: ->
    <WithScope className="header-filters" filters={@state.filters} onChange={@handleChange}>
      <Dropdown name="conditions" title="筛选">
        <Dropdown.SubDropdown name="rare" title="稀有度">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="★"/>
          <Dropdown.Item value={2} title="★★"/>
          <Dropdown.Item value={3} title="★★★"/>
          <Dropdown.Item value={4} title="★★★★"/>
          <Dropdown.Item value={5} title="★★★★★"/>
          <Dropdown.Item value={[3,4,5]} title="★★★以上"/>
          <Dropdown.Item value={[4,5]} title="★★★★以上"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="element" title="元素">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="火"/>
          <Dropdown.Item value={2} title="水"/>
          <Dropdown.Item value={3} title="风"/>
          <Dropdown.Item value={4} title="光"/>
          <Dropdown.Item value={5} title="暗"/>
          <Dropdown.Item value={[1,2,3]} title="火/水/风"/>
          <Dropdown.Item value={[4,5]} title="光/暗"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="weapon" title="武器">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="斩击"/>
          <Dropdown.Item value={2} title="突击"/>
          <Dropdown.Item value={3} title="打击"/>
          <Dropdown.Item value={4} title="弓箭"/>
          <Dropdown.Item value={5} title="魔法"/>
          <Dropdown.Item value={6} title="铳弹"/>
          <Dropdown.Item value={7} title="回复"/>
          <Dropdown.Item value={[1,2,3]} title="斩/突/打"/>
          <Dropdown.Item value={[4,5,6]} title="弓/魔/铳"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="type" title="成长">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="早熟"/>
          <Dropdown.Item value={2} title="平均"/>
          <Dropdown.Item value={3} title="晚成"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="aarea" title="攻击距离">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={$max: 50} title="近程"/>
          <Dropdown.Item value={$min: 50, $max: 150} title="中程"/>
          <Dropdown.Item value={$min: 150} title="远程"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="anum" title="攻击数量">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="1体"/>
          <Dropdown.Item value={2} title="2体"/>
          <Dropdown.Item value={3} title="3体"/>
          <Dropdown.Item value={4} title="4体"/>
          <Dropdown.Item value={5} title="5体"/>
          <Dropdown.Item value={[2,3]} title="2/3体"/>
          <Dropdown.Item value={[4,5]} title="4/5体"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="gender" title="性别">
          <Dropdown.Item value={undefined} title="全部"/>
          <Dropdown.Item value={1} title="不明"/>
          <Dropdown.Item value={2} title="男"/>
          <Dropdown.Item value={3} title="女"/>
        </Dropdown.SubDropdown>
        <Dropdown.SubDropdown name="country" title="国别">
        </Dropdown.SubDropdown>
        <Dropdown.Divider/>
        <Dropdown.Item value={{}} title="重置" active={false}/>
      </Dropdown>
      <Dropdown name="sortMode" title="筛选">
        <Dropdown.Item value="rare" title="稀有度"/>
        <Dropdown.Item value="dps" title="单体DPS"/>
        <Dropdown.Item value="mdps" title="多体DPS"/>
        <Dropdown.Item value="life" title="生命力"/>
        <Dropdown.Item value="atk" title="攻击"/>
        <Dropdown.Item value="aarea" title="攻击距离"/>
        <Dropdown.Item value="anum" title="攻击数量"/>
        <Dropdown.Item value="-aspd" title="攻击速度"/>
        <Dropdown.Item value="tenacity" title="韧性"/>
        <Dropdown.Item value="mspd" title="移动速度"/>
        <Dropdown.Item value="id" title="新品上架"/>
      </Dropdown>
      <Dropdown name="levelMode" title="等级">
        <Dropdown.Item value="zero" title="零觉零级"/>
        <Dropdown.Item value="maxlv" title="零觉满级"/>
        <Dropdown.Item value="mxlvgr" title="满觉满级"/>
      </Dropdown>
    </WithScope>

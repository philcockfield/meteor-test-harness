Ctrl.define
  'th-list-spec':
    init: ->
      @spec = @data
      @extension = @spec.extension
      @isBoolean = @extension?.type is 'boolean'

    created: ->
      # Handle Boolean toggling.
      if @isBoolean
        @autorun =>
          if ctrl = TestHarness.ctrl()
            key = @spec.name
            if Object.isFunction(ctrl[key])
              value = ctrl[key]()
              chk = @children.chk.api
              chk.isEnabled(Object.isBoolean(value))
              chk.toggle(value) if Object.isBoolean(value)


    helpers:
      count: (value) -> @prop 'count', value
      isBoolean: -> @isBoolean
      cssClasses: ->
        css = ''
        css += ' th-has-count' if @helpers.count() > 0 and not @isBoolean
        css



    events:
      'click': ->
        # Increment the count.
        count = @helpers.count() ? 0
        count += 1
        @helpers.count(count)

        # Toggle if the spec represents a Boolean property.
        TestHarness.toggle(@spec.name) if @isBoolean

        # Invoke the method.
        @spec.run { this:TestHarness, throw:true }, -> # Complete.


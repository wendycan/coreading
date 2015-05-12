Coreading.Views.Articles ||= {}
NS = "annotator-editor"
NSV = "annotator-viewer"

class Coreading.Views.Articles.ArticleView extends Backbone.View
  el: '#main-content'

  initialize: (opts)->
    @article = new Coreading.Models.Article(opts)
    @account = new Coreading.Models.Account
    @annotations = []
    @users = []
    @fields = []
    @fetchAccount()

  fetchAccount: (success, error)->
    if @account.get('unsync')
      @account.fetch_account(
        success: (data)=>
          @renderArticle()
          @textSelector($('#pdf-viewer-container'))
          @socket = io(Coreading.SocketPrefix + '/todos', {
            query: $.param({
                token: @account.get('auth_token')
                group: @article.get('group_id')
              }
            )}
          );
          if success?
            success()
        error: ->
          if error?
            error()
      )

  renderArticle: ->
    article = @article.toJSON()
    if article.path_type == 'online'
      @$el.html(_.template($('#t-article-show').html())(article: article)) 
    else
      @$el.html(_.template($('#t-article-pdf-show').html())(article: article)) 
      
      container = document.getElementById('pdf-viewer-container')
      pdfViewer = new PDFJS.PDFViewer({
        container: container
      })
      container.addEventListener 'pagesinit', ->
        pdfViewer.currentScaleValue = 'page-width'
      PDFJS.getDocument(article.pdf_url).then (pdfDocument)->
        pdfViewer.setDocument(pdfDocument)
        
      # container.addEventListener 'pagesloaded', ->
      #   alert('aa')

      @hoveHighlights()
      _this = @
      setTimeout ->
        _this.load()
      , 3000
      # Annotator.load();
    if article.public == 1
      $('#annotaions-meta').html _.template($('#t-annotation-meta').html())()

  textSelector: (element, options)->
    @element = element
    # @options = $.extend(true, {}, TextSelector.options, options)
    @options = options
    @element.on "mouseup", (e)=>
      @_checkForEndSelection(e)

  _checkForEndSelection: (e)->
    range = @captureDocumentSelection()[0]
    if !range or range.text().length <= 0
      return
    offset = @element.parent().offset()
    position = 
      top: e.pageY - offset.top
      left: e.pageX - offset.left
    annotation = {}
    annotation.range = range.serialize(@element[0], '.annotator-hl')
    annotation.quote = range.text()
    html = [
      '<div class="annotator-adder annotator-hide" style="display:none">',
      '<i class="fa fa-star"></i>',
      # '<i class="fa fa-underline"></i>',
      '<i class="fa fa-comment"></i>',
      '</div>'
    ].join('\n')
    $('#annotator-wedget').html(html)
    @showWidget(position, $('.annotator-adder'))
    _this = @

    $('.annotator-adder i.fa-comment').click (e)->
      annotation.tag = 'comment'
      _this.clickAdderBtn(annotation, position, e)

    $('.annotator-adder i.fa-star').click (e)->
      annotation.tag = 'star'
      annotation.username = _this.account.get('username')

      $('#annotator-wedget').empty()
      _this.createAnnotation annotation, (data)->
        annotation.id = data.id
        annotation.updated_at = jQuery.timeago(data.updated_at)

        Highlighter.draw(annotation)
  clickAdderBtn: (annotation, position, e)->
    html = [
      '<div class="annotator-outer annotator-editor annotator-hide">',
      '  <form class="annotator-widget">',
      '    <ul class="annotator-listing"></ul>',
      '    <div class="annotator-controls">',
      '       <i class="fa fa-times-circle annotator-cancel"></i>',
      '       <i class="fa fa-check annotator-save primary-color"></i>',
      '    </div>',
      '  </form>',
      '</div>'
    ].join('\n')
    $('#annotator-wedget').html(html);
    @addField({
      type: 'textarea'
    })
    @bindEvents(annotation);
    $('.annotator-editor').css({
      top: position.top,
      left: position.left
    })

  unbindEvents: ->
    $(document).unbind('.' + NS)

  bindEvents: (annotation)->
    @unbindEvents()
    self = @
    $(document).on("submit." + NS, 'form', (e)->
      self._onFormSubmit(e)
    )
    .on("click." + NS, '.annotator-save', (e)->
      self._onSaveClick(e,annotation)
    )
    .on("click." + NS, '.annotator-cancel', (e)->
      self._onCancelClick(e)
    )
    .on("mouseover." + NS, '.annotator-cancel', (e)->
      self._onCancelMouseover(e)
    )
    .on("keydown." + NS, 'textarea', (e)->
      self._onTextareaKeydown(e)
    )

  _onFormSubmit: (e)->
    # console.log('submit');

  load: ->
    _this = this
    $.ajax
      url: "#{Coreading.ApiPrefix}/annotations"
      type: 'GET'
      headers: 
        'Auth-Token': @account.get('auth_token')
      data: 
        article_id: @article.id
      success: (data)=>
        if @article.get('public') == 1
          data.forEach (d)=>
            anns = d.annotations
            username = d.username
            @users.push(username)
            anns.forEach (ann)=>
              ann.username = username
              ann.updated_at = jQuery.timeago(ann.updated_at)
              @annotations.push ann
        else
          data.forEach (ann)=>
            @annotations.push(ann)
        for annotation in @annotations
          annotation.range = Range.sniff JSON.parse(annotation.range)
          Highlighter.draw(annotation)
        @renderAnnotationsMeta()
      error: (e)->
        console.log(e)

  renderAnnotationsMeta: ->
    $('#annotations-count').text @annotations.length
    $('#annotations-count').attr 'data-annotations-count', @annotations.length
    if (@article.get('public') == 1) 
      $('#annotations-users').html('<p><small>批注成员</small><span class="user-list"></span></p>')
      @users.forEach (username)->
        $('#annotations-users .user-list').append('<span class="label radius" data-username=' + username + '>' + username + '</span>')

  _onSaveClick: (e, annotation)->
    text = $('.annotator-item textarea').val()
    annotation.text = text
    @annotations.push(annotation)
    # to create annotator
    $('#annotator-wedget').empty()
    annotation.username = @account.get('username')

    @createAnnotation annotation, (data)->
      annotation.id = data.id
      annotation.updated_at = jQuery.timeago(data.updated_at)

      Highlighter.draw(annotation)

  createAnnotation: (annotation, success, error)->
    $.ajax
      url: "#{Coreading.ApiPrefix}/annotations"
      type: 'POST'
      headers:
        'Auth-Token': @account.get('auth_token')
      data:
        text: annotation.text
        quote: annotation.quote
        range: JSON.stringify(annotation.range.toObject())
        user_id: @account.id
        article_id: @article.id
        tag: annotation.tag
      success: (data)->
        alertify.success("成功创建此批注")
        count = parseInt($('#annotations-count').attr('data-annotations-count')) + 1
        $('#annotations-count').attr('data-annotations-count', count)
        $('#annotations-count').text(count)
        if success then success(data)
      error: (e)->
        alertify.success("批注创建失败，请稍后重试。")
        if error then error(e)

  deleteAnnotation: (annotation, success, error)->
    $.ajax
      url: "#{Coreading.ApiPrefix}/annotations/#{annotation.id}"
      type: 'DELETE'
      headers:
        'Auth-Token': @account.get('auth_token')
      success: (data)->
        alertify.success("成功删除此批注")
        count = parseInt($('#annotations-count').attr('data-annotations-count')) - 1
        if count < 0
          count = 0
        $('#annotations-count').attr('data-annotations-count', count)
        $('#annotations-count').text(count)
        Highlighter.undraw(annotation)
        
        if success then success(data)
      error: (e)->
        alertify.success("批注删除失败，请稍后重试。")
        if error then error(e)

  _onCancelClick: (e)->
    $('#annotator-wedget').empty()

  _onCancelMouseover: (e)->
  # console.log('CancelMouseover')

  _onTextareaKeydown: (e)->
  # console.log('TextareaKeydown');

  addField: (options)->
    field = $.extend({
      id: 'annotator-field-' + 11
      type: 'input'
      label: ''
      load: ->
      submit: ->
    }, options)

    input = null
    element = $('<li class="annotator-item" />')

    field.element = element[0]

    if (field.type == 'textarea')
        input = $('<textarea />')
    else if (field.type == 'checkbox')
        input = $('<input type="checkbox" />')
    else if (field.type == 'input')
        input = $('<input />')
    else if (field.type == 'select')
        input = $('<select />')

    element.append(input)

    input.attr
      id: field.id,
      placeholder: '输入批注...'

    if field.type == 'checkbox'
      element.addClass('annotator-checkbox')
      element.append($('<label />', {
          'for': field.id,
          'html': field.label
      }))
    $(document).find('ul.annotator-listing').append(element)
    @fields.push(field)

    field.element

  showWidget: (position, el)->
    if (typeof position != 'undefined' and position != null) 
      el.css(
        top: position.top
        left: position.left
      )
    el.css('display', 'block')

  getSelect: ()->
    range = getSelection().getRangeAt(0)
    bRange = new Range.BrowserRange(range)
    sRange = bRange.serialize(document.body)
    return sRange

  hoveHighlights: ()->
    self = @
    $(document).on("mouseover." + NSV, '.annotator-hl', (event)->
      self._onHighlightMouseover(event)
    )
    # # .on("mouseleave." + NS, '.annotator-hl', function () {
    # #   self._startHideTimer();
    # # });

  _onHighlightMouseover: (e)->
    # if (@mouseDown) {
    #     return;
    # }
    annotations = $(e.target)
        .parents('.annotator-hl')
        .addBack()
        .map((_, elem)->
          return $(elem).data("annotation")
        )
        .toArray()
    html = [
      '<div class="annotator-outer annotator-viewer annotator-hide">',
      '<ul class="annotator-widget annotator-listing">',
      '</ul>',
      '</div>'
    ].join('\n')
    $('#annotator-wedget').html(html)
    for annotation in annotations
      if annotation.tag == 'comment'
        item_html = [
          '<li class="annotator-annotation annotator-item border-bottom">',
          '  <div class="annotator-controls">',
          '    <a',
          '       title="' + 'View as webpage' + '"',
          '       class="annotator-link">' + annotation.text + '</a>',
          '     <p>' + annotation.username + ' ' + annotation.updated_at + '添加</p>',
          '     <p class="text-right">',
          '       <i class="fa fa-pencil-square-o annotator-edit primary-color"></i>',
          '       <i class="fa fa-times-circle annotator-delete"></i>',
          '     </p>',
          '  </div>',
          '</li>',        
        ]
        if annotation.username != @account.get('username')
          item_html.splice(8,1)

      else
        item_html = [
          '<li class="annotator-annotation annotator-item border-bottom">',
          '  <div class="annotator-controls">',
          '    <p>' + annotation.username + ' ' + annotation.updated_at + '添加</p>',
          '    <p class="text-right"><i class="fa fa-times-circle annotator-delete"></i></p>',
          '  </div>',
          '</li>',
        ]
        if annotation.username != @account.get('username')
          item_html.splice(3,1)
      $('.annotator-listing').append(item_html.join('\n'))

    offset = @element.parent().offset()
    position = {
      top: e.pageY - offset.top
      left: e.pageX - offset.left
    }
    @showWidget(position, $('.annotator-viewer'));
    $('#annotator-wedget .annotator-delete').click =>
      $('#annotator-wedget').empty();
      @deleteAnnotation(annotation);

  captureDocumentSelection: ()->
    ranges = []
    rangesToIgnore = []
    selection = Util.getGlobal().getSelection();

    if selection.isCollapsed
      return []
    for i in [0...selection.rangeCount]
      r = selection.getRangeAt(i)
      browserRange = new Range.BrowserRange(r)
      normedRange = browserRange.normalize().limit(@element[0])
      # If the new range falls fully outside our @element, we should
      # add it back to the document but not return it from this method.
      if normedRange == null
        rangesToIgnore.push(r)
      else
        ranges.push(normedRange)

    # BrowserRange#normalize() modifies the DOM structure and deselects the
    # underlying text as a result. So here we remove the selected ranges and
    # reapply the new ones.
    selection.removeAllRanges()

    for i in [0...rangesToIgnore.length]
      selection.addRange(rangesToIgnore[i]);

    # Add normed ranges back to the selection
    for i in [0...ranges.length]
      range = ranges[i]
      drange = document.createRange()
      drange.setStartBefore(range.start)
      drange.setEndAfter(range.end)
      selection.addRange(drange)

    ranges
  # socket

